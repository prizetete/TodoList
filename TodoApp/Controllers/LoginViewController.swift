//
//  LoginViewController.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//

import RxCocoa
import RxSwift
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

    private var bag = DisposeBag()
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
        
        self.bindTextField()
    }
    
    // MARK: - Private Methods

    private func bindTextField() {
        let countTap = loginBtn
                    .rx
                    .tap
                    .scan(0) { (count, _) -> Int in
                        count + 1
                }
                
                countTap.map { (count) -> String in
                    "Count : \(count)"
                    }
                    .bind(to: loginBtn.rx.title())
                    .disposed(by: bag)
                
//                countTap.map { (count) -> Bool in
//                    count > 5
//                    }
//                    .bind(to: loginBtn.rx.isEnabled)
//                    .disposed(by: bag)
        
//        let usr = self.userNameTextField
//            .rx
//            .text
//            .orEmpty
//            .asObservable()
//            .map { (str) -> Bool in
//                str.isValidEmail()
//            }
//
//        let pwd = self.passwordTextField
//            .rx
//            .text
//            .orEmpty
//            .asObservable()
//            .map { (str) -> Bool in
//                str.isValidPassword()
//            }
//
//        Observable
//            .combineLatest(usr, pwd) { isValidUsr, isValidPwd in
//                isValidUsr && isValidPwd
//            }
//            .bind(to: self.loginBtn.rx.isEnabled)
//            .disposed(by: bag)
    }
    
    @objc private func register() {
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewControllerID") as! RegisterViewController
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc private func login() {
//        self.oUserAction.login(email: self.userNameTextField.text!, password: self.passwordTextField.text!)
    }
}

extension LoginViewController: UserActionViewModelDelegate {
    func loginSuccess(data: LoginResponse) {
        UserProfileManager.setUserDefault(data)
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TodoListViewControllerID") as! TodoListViewController
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func loginFail(error: Error) {
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
