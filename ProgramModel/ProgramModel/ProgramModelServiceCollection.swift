//
//  ProgramModelServiceCollection.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 06/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Swinject

public extension Container {
    func addProgram() {
        let factory = CardNodeFactory()
        
        register(CardNodeFactory.self) { _ in factory }
            .inObjectScope(.container)
        
        register(CardCollection.self) { _ in factory }
            .inObjectScope(.container)
        
        register(CardGraphDeserializer.self) { container in
            let factory = container.resolve(CardNodeFactory.self)!
            return CardGraphDeserializerImpl(factory: factory)
        }
        
        register(ProgramEditor.self) { container in
            let factory = container.resolve(CardNodeFactory.self)!
            return ProgramEditor(factory: factory)
        }
    }
}
