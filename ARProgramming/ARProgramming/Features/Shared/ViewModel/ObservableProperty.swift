//
//  ObservableProperty.swift
//  ARProgramming
//
//  Created by Kasper Schultz Davidsen on 14/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

/// A wrapper allowing clients to observe changes to a value. This is similar to the concept of binding from MVVM.
///
/// Observers are registered in the form of closures that will be called whenever the wrapped value is changed. Since these closures are likely not retained by the client that created them, they can be removed from this property using an Observer object returned from the two observe() methods.
///
/// Furthermore, a property will capture all of its observers strongly. Thus, a client is responsible for releasing its observers on a property before it is deallocated to avoid memory leaks. This is only important if the property can outlive the client, since once the property is deallocated, all its observing closures will be deallocated as well. Failing to release an observer should not result in a retain cycle.
///
/// To avoid a retain cycle, all registered observers should not capture their client object strongly, unless the client object only captures this property weakly or not at all.
///
/// A property will not retain itself just because it has active observers. As such, to prevent the property from being deallocated, it should be retained strongly by a client object.
class ImmutableObservableProperty<T> {
    
    fileprivate(set) var value: T {
        didSet {
            notifyObservers()
        }
    }
    private lazy var observers = [UUID:(T) -> Void]()
    
    /// Constructs a new property with the specified initial value. This property has no observers yet.
    ///
    /// - Parameter initial: The initial value wrapped by this property.
    init(_ initial: T) {
        value = initial
    }
    
    /// Start listening for changes to the value wrapped inside this property.
    ///
    /// The closure is automatically notified of the current value wrapped by this property. Thus, the closure will be called before this method returns.
    ///
    /// - Parameter closure: The closure to be notified of changes to the value.
    /// - Returns: An object that can be used to remove the observer from this property.
    func observe(withClosure closure: @escaping (T) -> Void) -> Observer {
        let observer = observeFuture(withClosure: closure)
        closure(value)
        return observer
    }
    
    /// Start listening for changes to the value wrapped inside this property.
    ///
    /// The closure is not notified of the current value wrapped by this property.
    ///
    /// - Parameter closure: The closure to be notified of changes to the value.
    /// - Returns: An object that can be used to remove the observer from this property.
    func observeFuture(withClosure closure: @escaping (T) -> Void) -> Observer {
        let uuid = UUID()
        observers[uuid] = closure
        
        //Return an object that can be used to remove the observer again, but without retaining this porperty in memory. If the property is released, so are the observers, and then there is not need to release them explicitly.
        return PropertyObserver { [weak self] in
            self?.removeObserver(withKey: uuid)
        }
    }
    
    /// Remove an observer from this property.
    ///
    /// The observer will no longer receive updates when the value wrapped in this property is changed.
    ///
    /// - Parameter key: The UUID of the observer to remove.
    private func removeObserver(withKey key: UUID) {
        observers[key] = nil
    }
    
    private func notifyObservers() {
        for observer in observers.values {
            observer(value)
        }
    }
}

extension ImmutableObservableProperty where T: ExpressibleByNilLiteral {
    
    /// Constructs a new property with the initial value nil. This property has no observers yet.
    convenience init() {
        self.init(nil)
    }
}

/// A wrapper allowing clients to observe changes to a value and/or change the value at will.
///
/// If an observer changes the value of this property, it will also be notified of the change.
class ObservableProperty<T>: ImmutableObservableProperty<T> {
    
    override var value: T {
        get {
            return super.value
        }
        set {
            super.value = newValue
        }
    }
}
