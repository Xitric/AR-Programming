//
//  LinkComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import GameplayKit
import simd

public class LinkComponent: GKComponent {

    private var deltaMatrix: simd_double4x4!

    public let otherEntity: Entity

    public init(otherEntity: Entity) {
        self.otherEntity = otherEntity
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func didAddToEntity() {
        guard let transform = entity?.component(subclassOf: TransformComponent.self),
            let otherTransform = otherEntity.component(subclassOf: TransformComponent.self)
            else { return }

        let toParentMatrix = simd_double4x4(translation: transform.location,
                                             rotation: transform.rotation).inverse
        let childMatrix = simd_double4x4(translation: otherTransform.location,
                                         rotation: otherTransform.rotation)
        deltaMatrix = toParentMatrix * childMatrix
    }

    override public func update(deltaTime seconds: TimeInterval) {
        guard let transform = entity?.component(subclassOf: TransformComponent.self),
            let otherTransform = otherEntity.component(subclassOf: TransformComponent.self)
            else { return }

        let parentMatrix = simd_double4x4(translation: transform.location,
                                          rotation: transform.rotation)
        let resultMatrix = parentMatrix * deltaMatrix

        otherTransform.location = resultMatrix.translation
        otherTransform.rotation = resultMatrix.rotation
    }
}
