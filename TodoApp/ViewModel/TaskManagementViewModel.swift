//
//  TaskManagementViewModel.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 5/4/2564 BE.
//

import Foundation

protocol TaskManagementViewModelDelegate: NSObjectProtocol {
    func getAllTask(data: [TaskResponse])
    func getAllTaskFail(error: Error)
    
    func addNewTask()
    func addNewTaskFail(error: Error)
    
    func getTaskById(data: TaskResponse)
    func getTaskByIdFail(error: Error)
    
    func updateTaskSuccess(action: EditAction)
    func updateTaskFail(error: Error)
    
    func removeTaskSuccess(idxPath: IndexPath)
    func removeTaskFail(error: Error)
}

extension TaskManagementViewModelDelegate {
    func getAllTask(data: [TaskResponse]) {}
    func getAllTaskFail(error: Error) {}
    
    func addNewTask() {}
    func addNewTaskFail(error: Error) {}
    
    func getTaskById(data: TaskResponse) {}
    func getTaskByIdFail(error: Error) {}
    
    func updateTaskSuccess(action: EditAction) {}
    func updateTaskFail(error: Error) {}
    
    func removeTaskSuccess(idxPath: IndexPath) {}
    func removeTaskFail(error: Error) {}
}

class TaskManagementViewModel: NSObject {
    weak var delegate: TaskManagementViewModelDelegate!
    
    override init() {}
    
    public func getAllTask() {
        TodoService.shared.getAllTask { fetchResult in
            switch fetchResult {
            case .success(let response):
                self.delegate.getAllTask(data: (response.value?.task)!)
            case .failure(let error):
                self.delegate.getAllTaskFail(error: error)
            }
        }
    }
    
    public func addNewTask(descp: String) {
        TodoService.shared.addTodoTask(description: descp) { fetchResult in
            switch fetchResult {
            case .success:
                self.delegate.addNewTask()
            case .failure(let error):
                self.delegate.addNewTaskFail(error: error)
            }
        }
    }
    
    public func getTaskById(id: String) {
        TodoService.shared.getTaskById(id: id) { fetchResult in
            switch fetchResult {
            case .success(let response):
                self.delegate.getTaskById(data: (response.value?.task)!)
            case .failure(let error):
                self.delegate.getTaskByIdFail(error: error)
            }
        }
    }
    
    public func updateTask(id: String, updateValue: String, action: EditAction) {
        TodoService.shared.updateTask(id: id, updateValue: updateValue, editAction: action) { fetchResult in
            switch fetchResult {
            case .success:
                self.delegate.updateTaskSuccess(action: action)
            case .failure(let error):
                self.delegate.updateTaskFail(error: error)
            }
        }
    }
    
    public func removeTask(id: String, idxPath: IndexPath) {
        TodoService.shared.removeTask(id: id) { fetchResult in
            switch fetchResult {
            case .success:
                self.delegate.removeTaskSuccess(idxPath: idxPath)
            case .failure(let error):
                self.delegate.removeTaskFail(error: error)
            }
        }
    }
}
