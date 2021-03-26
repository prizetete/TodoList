//
//  GetAllTaskResponse.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 25/3/2564 BE.
//

import Foundation
import ObjectMapper

class GetAllTaskResponse: Mappable {
    // Mandatory
    var count: Int?
    var task: [TaskResponse]?

    // MARK: Mappable

    required init?(map: Map) {
        guard validateKeys(json: map.JSON,
                           keys: [])
        else {
            return nil
        }
    }

    func mapping(map: Map) {
        count <- map["count"]
        task <- map["data"]
    }
}
