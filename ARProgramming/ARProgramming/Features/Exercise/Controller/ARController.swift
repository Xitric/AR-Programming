//
//  ARController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 12/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class ARController: NSObject {

    private var configuration: ARWorldTrackingConfiguration!
    private var options: ARSession.RunOptions!
    private weak var currentPlane: SCNNode?
    private var currentPlaneAnchor: ARAnchor?

    weak var updateDelegate: UpdateDelegate?
    weak var frameDelegate: FrameDelegate?
    weak var planeDetectorDelegate: PlaneDetectorDelegate?

    // MARK: - Injected properties
    weak var sceneView: ARSCNView! {
        didSet {
            sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
            sceneView.autoenablesDefaultLighting = true

            configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal

            options = [.resetTracking]

            sceneView.delegate = self
            sceneView.session.delegate = self
        }
    }

    // MARK: - Life cycle
    func start() {
        sceneView.session.run(configuration, options: options)
    }

    func stop() {
        sceneView.session.pause()
    }

    func restart() {
        stop()
        sceneView.session.run(configuration, options: [options, ARSession.RunOptions.removeExistingAnchors])
    }
}

// MARK: - ARSCNViewDelegate
extension ARController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            if let currentPlaneAnchor = currentPlaneAnchor {
                sceneView.session.remove(anchor: currentPlaneAnchor)
            }

            handlePlaneDetected(planeAnchor: planeAnchor, node: node)
            currentPlaneAnchor = planeAnchor
        }
    }

    private func handlePlaneDetected(planeAnchor: ARPlaneAnchor, node: SCNNode) {
        if planeDetectorDelegate?.shouldDetectPlanes(self) ?? false {
            if currentPlane == nil, let plane = planeDetectorDelegate?.createPlaneNode(self) {
                currentPlane = plane
                sceneView.scene.rootNode.addChildNode(plane)

                if let frame = sceneView.session.currentFrame {
                    updatePlanePosition(in: frame)
                }
            }
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        updateDelegate?.update(currentTime: time)
    }
}

// MARK: - ARSessionDelegate
extension ARController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let orientation = CGImagePropertyOrientation(UIDevice.current.orientation)
        let image = frame.capturedImage
        frameDelegate?.frameScanner(self, didUpdate: image, withOrientation: orientation)

        if currentPlane == nil {
            if currentPlaneAnchor != nil {
                sceneView.session.remove(anchor: currentPlaneAnchor!)
                currentPlaneAnchor = nil
            }
        } else if planeDetectorDelegate?.shouldDetectPlanes(self) ?? false {
            updatePlanePosition(in: frame)
        }
    }

    private func updatePlanePosition(in frame: ARFrame) {
        if let hit = frame.hitTest(CGPoint(x: 0.5, y: 0.5), types: [.existingPlane]).first {
            currentPlane?.position = SCNVector3(hit.worldTransform.translation)
        }
    }
}
