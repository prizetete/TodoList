//
//  UserResponse.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 25/3/2564 BE.
//

import Foundation
import ObjectMapper

class UserResponse: Mappable {
    // Mandatory
    var age: Int?
    var _id: String?
    var name: String?
    var email: String?
    var createdAt: String?
    var updatedAt: String?
    var __v: Int?

    // MARK: Mappable

    required init?(map: Map) {
        guard validateKeys(json: map.JSON,
                           keys: [])
        else {
            return nil
        }
    }

    func mapping(map: Map) {
        age <- map["age"]
        _id <- map["_id"]
        name <- map["name"]
        email <- map["email"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        __v <- map["__v"]
    }
}
