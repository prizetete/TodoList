//
//  TodoService.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 25/3/2564 BE.
//

import Alamofire
import AlamofireObjectMapper
import SwiftyUserDefaults

enum EditAction {
    case completed
    case update
}

class TodoService: NSObject {
    static var shared = TodoService()
    
    let baseURL = AppConfig.baseUrl
    
    public func login(email: String, password: String, completionHandler: @escaping (FetchResult<DataResponse<LoginResponse>>) -> Void) {
        let url = self.baseURL + "/user/login"
        let params = LoginRequest(email: email, password: password)?.dictionaryRepresentation()
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<LoginResponse>) in
                switch response.result {
                case .success:
                    completionHandler(.success(result: response))
                case let .failure(error):
                    completionHandler(.failure(error: error))
                }
            }
    }
    
    public func register(email: String, password: String, name: String, age: Int, completionHandler: @escaping (FetchResult<DataResponse<LoginResponse>>) -> Void) {
        let url = self.baseURL + "/user/register"
        let params = RegisterRequest(email: email, password: password, age: age, name: name)?.dictionaryRepresentation()
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<LoginResponse>) in
                switch response.result {
                case .success:
                    completionHandler(.success(result: response))
                case let .failure(error):
                    completionHandler(.failure(error: error))
                }
            }
    }
    
    public func logout(completionHandler: @escaping (FetchResult<DataResponse<LogoutResponse>>) -> Void) {
        let url = self.baseURL + "/user/logout"
        let token = Defaults[.token] ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        print(headers)
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<LogoutResponse>) in
                switch response.result {
                case .success:
                    completionHandler(.success(result: response))
                case let .failure(error):
                    completionHandler(.failure(error: error))
                }
            }
    }
    
    public func createTodo(description: String, completionHandler: @escaping (FetchResult<DataResponse<AddTaskResponse>>) -> Void) {
        let url = self.baseURL + "/task"
        let token = Defaults[.token] ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        let params = CreateTodoRequest(desc: description)?.dictionaryRepresentation()
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<AddTaskResponse>) in
                switch response.result {
                case .success:
                    completionHandler(.success(result: response))
                case let .failure(error):
                    completionHandler(.failure(error: error))
                }
            }
    }
    
    public func getAllTask(completionHandler: @escaping (FetchResult<DataResponse<GetAllTaskResponse>>) -> Void) {
        let url = self.baseURL + "/task"
        let token = Defaults[.token] ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<GetAllTaskResponse>) in
                switch response.result {
                case .success:
                    completionHandler(.success(result: response))
                case let .failure(error):
                    completionHandler(.failure(error: error))
                }
            }
    }
    
    public func getTaskById(id: String, completionHandler: @escaping (FetchResult<DataResponse<AddTaskResponse>>) -> Void) {
        let url = self.baseURL + "/task/\(id)"
        let token = Defaults[.token] ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<AddTaskResponse>) in
                switch response.result {
                case .success:
                    completionHandler(.success(result: response))
                case let .failure(error):
                    completionHandler(.failure(error: error))
                }
            }
    }
    
    public func updateTask(id: String, updateValue: String = "", editAction: EditAction, completionHandler: @escaping (FetchResult<DataResponse<AddTaskResponse>>) -> Void) {
        let url = self.baseURL + "/task/\(id)"
        let token = Defaults[.token] ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        var params: [String: Any] = [:]
        switch editAction {
        case .completed:
            params = [
                "completed": true
            ]
        case .update:
            params = [
                "description": updateValue
            ]
        }
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<AddTaskResponse>) in
                switch response.result {
                case .success:
                    completionHandler(.success(result: response))
                case let .failure(error):
                    completionHandler(.failure(error: error))
                }
            }
    }
    
    public func removeTask(id: String, completionHandler: @escaping (FetchResult<DataResponse<AddTaskResponse>>) -> Void) {
        let url = self.baseURL + "/task/\(id)"
        let token = Defaults[.token] ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<AddTaskResponse>) in
                switch response.result {
                case .success:
                    completionHandler(.success(result: response))
                case let .failure(error):
                    completionHandler(.failure(error: error))
                }
            }
    }
}
