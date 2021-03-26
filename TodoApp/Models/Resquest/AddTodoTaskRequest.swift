//
//  AddTodoTaskRequest.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 25/3/2564 BE.
//

struct AddTodoTaskRequest: DictionaryMappable {
    // Mandatory
    var description: String

    // MARK: - Initializer

    init?(desc: String) {
        description = desc
    }

    // MARK: - DictionaryMappable

    init?(dictionary: [String: Any]) {
        description = dictionary["description"] as? String ?? ""
    }

    func dictionaryRepresentation() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["description"] = description
        return dictionary
    }
}
