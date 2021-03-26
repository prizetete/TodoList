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
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        self.setupView()
    }
    
    // MARK: - UI Setup

    private func setupView() {
        self.navigationItem.title = "Login"
        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = .orange
        self.navigationController?.navigationBar.barTintColor = .orange
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.passwordTextField.isSecureTextEntry = true
        
        self.loginBtn.layer.cornerRadius = 8.0
        self.loginBtn.addTarget(self, action: #selector(self.login), for: .touchUpInside)
        let rightBtn = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(self.register))
        rightBtn.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    // MARK: - Private Methods

    private func setUserDefault(_ result: LoginResponse) {
        Defaults[._id] = result.user?._id
        Defaults[.createdAt] = result.user?.createdAt
        Defaults[.email] = result.user?.email
        Defaults[.name] = result.user?.name
        Defaults[.updatedAt] = result.user?.updatedAt
        Defaults[.age] = result.user?.age
        Defaults[.v] = result.user?.__v
        
        Defaults[.token] = result.token
    }
    
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
        
        TodoService.shared.login(email: self.userNameTextField.text ?? "", password: self.passwordTextField.text ?? "") { [weak self] fetchResult in
            guard let strongSelf = self else { return }
            strongSelf.loginBtn.isUserInteractionEnabled = true
            switch fetchResult {
            case .success(let response):
                strongSelf.setUserDefault((response.value)!)
                UserProfileManager.setUserLoginState(isLogin: true)
                let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TodoListViewControllerID") as! TodoListViewController
                
                strongSelf.navigationController?.pushViewController(destinationVC, animated: true)
            case .failure(let error):
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
}
