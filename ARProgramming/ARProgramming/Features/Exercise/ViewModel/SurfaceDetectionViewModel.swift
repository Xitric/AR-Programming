//
//  SurfaceDetectionViewModel.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 12/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

class SurfaceDetectionViewModel: SurfaceDetectionViewModeling {

    private let _planeDetected = ObservableProperty<Void>(())
    private lazy var root: SCNNode = {
        let node = SCNNode()
        node.addChildNode(ground)
        return node
    }()
    private lazy var ground: SCNNode = {
        let node = SCNNode(geometry: SCNPlane(width: 0.2, height: 0.2))
        node.eulerAngles.x = -.pi / 2
        node.geometry?.materials.first?.diffuse.contents = UIImage(named: "SurfaceArea.png")
        return node
    }()

    var planeDetected: ImmutableObservableProperty<Void> {
        return _planeDetected
    }

    func placeLevel(_ level: LevelSceneViewModeling) {
        level.anchor(at: root)
    }

    // MARK: - PlaneDetectorDelegate
    func shouldDetectPlanes(_ detector: ARController) -> Bool {
        return root.childNodes.count == 1 && root.childNodes.contains(ground)
    }

    func createPlaneNode(_ detector: ARController) -> SCNNode {
        DispatchQueue.main.async { [weak self] in
            self?._planeDetected.value = ()
        }
        return root
    }
}

/// View model that acts as a data source and delegate for AR plane detection.
protocol SurfaceDetectionViewModeling: PlaneDetectorDelegate {

    var planeDetected: ImmutableObservableProperty<Void> { get }

    func placeLevel(_ level: LevelSceneViewModeling)
}
