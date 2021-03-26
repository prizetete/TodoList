//
//  AddTaskResponse.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 25/3/2564 BE.
//

import Foundation
import ObjectMapper

class AddTaskResponse: Mappable {
    // Mandatory
    var status: Bool?
    var task: TaskResponse?

    // MARK: Mappable

    required init?(map: Map) {
        guard validateKeys(json: map.JSON,
                           keys: [])
        else {
            return nil
        }
    }

    func mapping(map: Map) {
        status <- map["success"]
        task <- map["data"]
    }
}
