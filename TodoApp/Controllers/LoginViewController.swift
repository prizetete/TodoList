//
//  LoginViewController.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//

import SwiftyUserDefaults
import UIKit

class LoginViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField.isSecureTextEntry = true
        }
    }

    @IBOutlet var loginBtn: UIButton! {
        didSet {
            self.loginBtn.layer.cornerRadius = 8.0
            self.loginBtn.addTarget(self, action: #selector(self.login), for: .touchUpInside)
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
        self.navigationItem.title = "Login"
        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = .orange
        self.navigationController?.navigationBar.barTintColor = .orange
        self.navigationController?.navigationBar.isTranslucent = false
        
        let rightBtn = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(self.register))
        rightBtn.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    // MARK: - Private Methods

    @objc private func register() {
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewControllerID") as! RegisterViewController
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc private func login() {
        self.loginBtn.isUserInteractionEnabled = false
        
        guard let email = self.userNameTextField.text, email != "", email.isValidEmail() else {
            self.userNameTextField.becomeFirstResponder()
            let alert = UIAlertController(title: "Alert", message: "กรอก email ใหม่", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.loginBtn.isUserInteractionEnabled = true
            return
        }
        guard let password = self.passwordTextField.text, password != "", password.isValidPassword() else {
            self.passwordTextField.becomeFirstResponder()
            let alert = UIAlertController(title: "Alert", message: "กรอก password ใหม่", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.loginBtn.isUserInteractionEnabled = true
            return
        }
        self.oUserAction.login(email: email, password: password)
    }
}

extension LoginViewController: UserActionViewModelDelegate {
    func loginSuccess(data: LoginResponse) {
        self.loginBtn.isUserInteractionEnabled = true
        UserProfileManager.setUserDefault(data)
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TodoListViewControllerID") as! TodoListViewController
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func loginFail(error: Error) {
        self.loginBtn.isUserInteractionEnabled = true
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
