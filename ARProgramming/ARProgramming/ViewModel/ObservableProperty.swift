//
//  ObservableProperty.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 14/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

/// A wrapper allowing clients to observe changes to a value. This is similar to the concept of binding from MVVM.
class ObservableProperty<T> {
    
    var value: T {
        didSet {
             onValue?(value)
        }
    }
    
    var onValue: ((T) -> Void)?
    
    init(_ initial: T) {
        value = initial
    }
}

extension ObservableProperty where T: ExpressibleByNilLiteral {
    convenience init() {
        self.init(nil)
    }
}
