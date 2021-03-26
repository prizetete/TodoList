//
//  TaskResponse.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 25/3/2564 BE.
//

import Foundation
import ObjectMapper

class TaskResponse: Mappable {
    // Mandatory
    var completed: Bool?
    var _id: String?
    var description: String?
    var owner: String?
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
        completed <- map["completed"]
        _id <- map["_id"]
        description <- map["description"]
        owner <- map["owner"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        __v <- map["__v"]
    }
}
