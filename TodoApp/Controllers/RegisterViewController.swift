//
//  RegisterViewController.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//

import UIKit

class RegisterViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var emailTextField: UITextField! {
        didSet {
            self.emailTextField.textContentType = .emailAddress
        }
    }

    @IBOutlet var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField.isSecureTextEntry = true
        }
    }

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField! {
        didSet {
            self.ageTextField.keyboardType = .numberPad
        }
    }

    @IBOutlet var registerBtn: UIButton! {
        didSet {
            self.registerBtn.layer.cornerRadius = 8.0
            self.registerBtn.addTarget(self, action: #selector(self.register), for: .touchUpInside)
        }
    }

    // MARK: - Properties

    private var oUserAction: UserActionViewModel!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        self.oUserAction = UserActionViewModel()
        self.oUserAction.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupView()
    }

    // MARK: - UI Setup

    private func setupView() {
        self.navigationItem.title = "Register"
        self.view.backgroundColor = .orange
        self.navigationController?.navigationBar.barTintColor = .orange
        self.navigationController?.navigationBar.isTranslucent = false
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

        self.oUserAction.register(email: email, password: password, name: name, age: Int(age) ?? 0)
    }
}

extension RegisterViewController: UserActionViewModelDelegate {
    func registerSuccess() {
        self.registerBtn.isUserInteractionEnabled = true
        let alert = UIAlertController(title: "Alert", message: "Register Success", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func registerFail(error: Error) {
        self.registerBtn.isUserInteractionEnabled = true
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
