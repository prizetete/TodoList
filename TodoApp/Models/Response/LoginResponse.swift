//
//  LoginResponse.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 25/3/2564 BE.
//

import Foundation
import ObjectMapper

class LoginResponse: Mappable {
    // Mandatory
    var user: UserResponse?
    var token: String?

    // MARK: Mappable

    required init?(map: Map) {
        guard validateKeys(json: map.JSON,
                           keys: [])
        else {
            return nil
        }
    }

    func mapping(map: Map) {
        user <- map["user"]
        token <- map["token"]
    }
}
