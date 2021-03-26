//
//  StringExtension.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 26/3/2564 BE.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    func isValidPassword() -> Bool {
        let pwdRegEx = "[A-Z0-9a-z]{8,64}"
        let pwdPred = NSPredicate(format: "SELF MATCHES %@", pwdRegEx)
        return pwdPred.evaluate(with: self)
    }

    func isValidName() -> Bool {
        let nameRegEx = "[A-Za-z]{3,64}"
        let namePred = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: self)
    }

    func isValidAge() -> Bool {
        let ageRegEx = "[0-9]+"
        let agePred = NSPredicate(format: "SELF MATCHES %@", ageRegEx)
        return agePred.evaluate(with: self)
    }
}
