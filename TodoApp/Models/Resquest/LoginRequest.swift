//
//  LoginRequest.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 25/3/2564 BE.
//

struct LoginRequest: DictionaryMappable {
    // Mandatory
    var email: String
    var password: String
    
    // MARK: - Initializer

    init?(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    // MARK: - DictionaryMappable

    init?(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["email"] = email
        dictionary["password"] = password
        
        return dictionary
    }
}
