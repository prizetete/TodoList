//
//  UserActionViewModel.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 5/4/2564 BE.
//

import Foundation

protocol UserActionViewModelDelegate: NSObjectProtocol {
    func loginSuccess(data: LoginResponse)
    func loginFail(error: Error)
    
    func registerSuccess()
    func registerFail(error: Error)
    
    func logoutSuccess(data: LogoutResponse)
    func logoutFail(error: Error)
}

extension UserActionViewModelDelegate {
    func loginSuccess(data: LoginResponse) {}
    func loginFail(error: Error) {}
    
    func registerSuccess() {}
    func registerFail(error: Error) {}
    
    func logoutSuccess(data: LogoutResponse) {}
    func logoutFail(error: Error) {}
}

class UserActionViewModel: NSObject {
    weak var delegate: UserActionViewModelDelegate!
    
    override init() {}
    
    func login(email: String, password: String) {
        TodoService.shared.login(email: email, password: password) { fetchResult in
            switch fetchResult {
            case .success(let response):
                self.delegate.loginSuccess(data: response.value!)
            case .failure(let error):
                self.delegate.loginFail(error: error)
            }
        }
    }
    
    func register(email: String, password: String, name: String, age: Int) {
        TodoService.shared.register(email: email, password: password, name: name, age: age) { fetchResult in
            switch fetchResult {
            case .success:
                self.delegate.registerSuccess()
            case .failure(let error):
                self.delegate.registerFail(error: error)
            }
        }
    }
    
    func logout() {
        TodoService.shared.logout { fetchResult in
            switch fetchResult {
            case .success(let response):
                self.delegate.logoutSuccess(data: response.value!)
            case .failure(let error):
                self.delegate.logoutFail(error: error)
            }
        }
    }
}
