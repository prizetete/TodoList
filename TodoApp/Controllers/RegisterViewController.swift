//
//  RegisterViewController.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        self.setupView()
    }
    
    private func setupView() {
        self.navigationItem.title = "Register"
        self.view.backgroundColor = .orange
        self.navigationController?.navigationBar.barTintColor = .orange
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.registerBtn.layer.cornerRadius = 8.0
        
        self.emailTextField.textContentType = .emailAddress
        self.ageTextField.keyboardType = .numberPad
        self.passwordTextField.isSecureTextEntry = true
        self.registerBtn.addTarget(self, action: #selector(self.register), for: .touchUpInside)
    }
    
    @objc func register() {
        self.registerBtn.isUserInteractionEnabled = false
        guard let email = self.emailTextField.text, email != "", self.isValidEmail(email) else {
            print("case 1")
            self.registerBtn.isUserInteractionEnabled = true
            return
        }
        guard let password = self.passwordTextField.text, password != "", self.isValidPassword(password) else {
            print("case 2")
            self.registerBtn.isUserInteractionEnabled = true
            return
        }
        guard let name = self.nameTextField.text, name != "", self.isValidName(name) else {
            print("case 3")
            self.registerBtn.isUserInteractionEnabled = true
            return
        }
        guard let age = self.ageTextField.text, age != "", self.isValidAge(age) else {
            print("case 4")
            self.registerBtn.isUserInteractionEnabled = true
            return
        }
        
        // connect api
        TodoService.shared.register(email: email, password: password, name: name, age: Int(age)!) { [weak self] fetchResult in
            guard let strongSelf = self else { return }
            strongSelf.registerBtn.isUserInteractionEnabled = true
            switch fetchResult {
            case .success:
                strongSelf.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print("register fail error: \(error)")
            }
        }
        print("complete")
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ pwd: String) -> Bool {
        let pwdRegEx = "[A-Z0-9a-z]{8,64}"
        let pwdPred = NSPredicate(format: "SELF MATCHES %@", pwdRegEx)
        return pwdPred.evaluate(with: pwd)
    }
    
    func isValidName(_ name: String) -> Bool {
        let nameRegEx = "[A-Za-z]{3,64}"
        let namePred = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name)
    }
    
    func isValidAge(_ age: String) -> Bool {
        let ageRegEx = "[0-9]+"
        let agePred = NSPredicate(format: "SELF MATCHES %@", ageRegEx)
        return agePred.evaluate(with: age)
    }
}
