//
//  RegisterViewController.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//

import UIKit
import RxCocoa
import RxSwift

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
    private var bag = DisposeBag()
    
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
        self.bindRx()
    }
    
    private func bindRx() {
        let bEmailValidate = self.emailTextField
            .rx
            .text
            .orEmpty
            .asObservable()
            .map { (str) -> Bool in
                return str.isValidEmail()
            }
        
        let bPwdValidate = self.passwordTextField
            .rx
            .text
            .orEmpty
            .asObservable()
            .map { (str) -> Bool in
                return str.isValidPassword()
            }
        
        let bNameValidate = self.nameTextField
            .rx
            .text
            .orEmpty
            .asObservable()
            .map { (str) -> Bool in
                return str.isValidName()
            }
        
        let bAgeValidate = self.ageTextField
            .rx
            .text
            .orEmpty
            .asObservable()
            .map { (str) -> Bool in
                return str.isValidAge()
            }
        
        Observable
            .combineLatest(bEmailValidate, bPwdValidate, bNameValidate, bAgeValidate) { (b1,b2,b3,b4) -> Bool in
                return !(b1 && b2 && b3 && b4)
            }
            .bind(to: self.registerBtn.rx.isHidden)
            .disposed(by: bag)
            
    }

    // MARK: - Private Methods

    @objc private func register() {
        self.oUserAction.register(email: self.emailTextField.text!, password: self.passwordTextField.text!, name: self.nameTextField.text!, age: Int(self.ageTextField.text!) ?? 0)
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
