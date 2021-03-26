//
//  LoginViewController.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//

import SwiftyUserDefaults
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    
    override func viewDidLoad() {
        self.setupView()
    }
    
    private func setupView() {
        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = .orange
        self.navigationController?.navigationBar.barTintColor = .orange
        self.navigationItem.title = "Login"
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.loginBtn.layer.cornerRadius = 8.0
        
        self.loginBtn.addTarget(self, action: #selector(self.login), for: .touchUpInside)
        let rightBtn = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(self.register))
        rightBtn.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    @objc private func login() {
        self.loginBtn.isUserInteractionEnabled = false
        
        TodoService.shared.login(email: "muh.nurali43@gmail.com", password: "12345678") { [weak self] fetchResult in
            guard let strongSelf = self else { return }
            strongSelf.loginBtn.isUserInteractionEnabled = true
            switch fetchResult {
            case .success(let response):
                print("login success")
                strongSelf.setUserDefault((response.value)!)
                UserProfileManager.setUserLoginState(isLogin: true)
                let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TodoListViewControllerID") as! TodoListViewController
                
                strongSelf.navigationController?.pushViewController(destinationVC, animated: true)
            case .failure(let error):
                print("login fail error: \(error)")
            }
        }
    }
    
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
}
