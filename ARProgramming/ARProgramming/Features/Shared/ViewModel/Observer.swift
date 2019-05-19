//
//  Observer.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 27/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

/// An object that can be used to release an observer from the property it is observing.
protocol Observer {

    /// Remove this observer from the property it is observing.
    ///
    /// If the property has already been deallocated, or if this observer has already been released, this method does nothing.
    func release()
}

struct PropertyObserver: Observer {

    private let performRelease: () -> Void

    init(_ releaser: @escaping () -> Void) {
        self.performRelease = releaser
    }

    func release() {
        performRelease()
    }
}
