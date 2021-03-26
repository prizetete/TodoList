//
//  LogoutResponse.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 25/3/2564 BE.
//

import Foundation
import ObjectMapper

class LogoutResponse: Mappable {
    // Mandatory
    var status: Bool?

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
    }
}
