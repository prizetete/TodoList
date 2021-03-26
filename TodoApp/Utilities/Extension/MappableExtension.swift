//
//  MappableExtension.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//

import Foundation
import ObjectMapper

extension Mappable {
    func validateKeys(json: [String: Any], keys: [String]) -> Bool {
        for key in keys where json[key] == nil {
            print("Failed to mapping: \(String(describing: self)), key: \(key)")
            return false
        }
        return true
    }
}
