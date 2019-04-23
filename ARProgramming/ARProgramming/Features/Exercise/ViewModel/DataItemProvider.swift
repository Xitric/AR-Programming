//
//  DataItemProvider.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 13/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import CoreServices

final class DataItemProvider: NSObject, NSItemProviderWriting, NSItemProviderReading {
    
    let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [(kUTTypeData) as String]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        completionHandler(data, nil)
        
        return nil
    }
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [(kUTTypeData) as String]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> DataItemProvider {
        return DataItemProvider(data: data)
    }
}
