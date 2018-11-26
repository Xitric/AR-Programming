//
//  Vector2.swift
//  AR Programming
//
//  Created by user143563 on 10/29/18.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class Vector2 {
    
    let x : Float
    let y : Float
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    func dot(with other: Vector2) -> Float {
        return self.x * other.x + self.y * other.y
    }
    
    func ortho() -> Vector2 {
        return Vector2(x: -y, y: x)
    }
    
    func length() -> Float {
        return sqrt(pow(x, 2) + pow(y, 2))
    }
    
    func normalize() -> Vector2 {
        let len = length()
        return Vector2(x: x / len, y: y / len)
    }
}
