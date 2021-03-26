import Foundation

protocol DictionaryMappable {
    associatedtype Ttype: Hashable
    init?(dictionary: [Ttype: Any])
    func dictionaryRepresentation() -> [Ttype: Any]
    static func modelsFromDictionaryArray(array: [Any]) -> [Self]
}

extension DictionaryMappable {
    static func modelsFromDictionaryArray(array: [Any]) -> [Self] {
        var models = [Self]()
        for item in array {
            guard let dictionary = item as? [Ttype: Any],
                let model = Self(dictionary: dictionary) else {
                    continue
            }
            models.append(model)
        }
        return models
    }
}
