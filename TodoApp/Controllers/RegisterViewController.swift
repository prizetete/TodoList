//
//  RegisterViewController.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//

import UIKit

class RegisterViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var registerBtn: UIButton!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        self.setupView()
    }

    // MARK: - UI Setup

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

    // MARK: - Private Methods

    @objc private func register() {
        self.registerBtn.isUserInteractionEnabled = false
        guard let email = self.emailTextField.text, email != "", email.isValidEmail() else {
            self.emailTextField.becomeFirstResponder()
            let alert = UIAlertController(title: "Alert", message: "กรอก email ใหม่", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.registerBtn.isUserInteractionEnabled = true
            return
        }
        guard let password = self.passwordTextField.text, password != "", password.isValidPassword() else {
            self.passwordTextField.becomeFirstResponder()
            let alert = UIAlertController(title: "Alert", message: "กรอก password ใหม่", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.registerBtn.isUserInteractionEnabled = true
            return
        }
        guard let name = self.nameTextField.text, name != "", name.isValidName() else {
            self.nameTextField.becomeFirstResponder()
            let alert = UIAlertController(title: "Alert", message: "กรอก name ใหม่", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.registerBtn.isUserInteractionEnabled = true
            return
        }
        guard let age = self.ageTextField.text, age != "", age.isValidAge() else {
            self.ageTextField.becomeFirstResponder()
            let alert = UIAlertController(title: "Alert", message: "กรอก age ใหม่", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.registerBtn.isUserInteractionEnabled = true
            return
        }

        TodoService.shared.register(email: email, password: password, name: name, age: Int(age)!) { [weak self] fetchResult in
            guard let strongSelf = self else { return }
            strongSelf.registerBtn.isUserInteractionEnabled = true
            switch fetchResult {
            case .success:
                let alert = UIAlertController(title: "Alert", message: "Register Success", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    strongSelf.navigationController?.popViewController(animated: true)
                }))
                strongSelf.present(alert, animated: true, completion: nil)

            case .failure(let error):
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
}
