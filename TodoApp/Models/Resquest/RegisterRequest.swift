//
//  RegisterRequest.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 25/3/2564 BE.
//

struct RegisterRequest: DictionaryMappable {
    // Mandatory
    var email: String
    var password: String
    var age: Int
    var name: String
    
    // MARK: - Initializer

    init?(email: String, password: String, age: Int, name: String) {
        self.email = email
        self.password = password
        self.age = age
        self.name = name
    }
    
    // MARK: - DictionaryMappable

    init?(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
    }
    
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["email"] = email
        dictionary["password"] = password
        dictionary["name"] = name
        dictionary["age"] = age
        return dictionary
    }
}
