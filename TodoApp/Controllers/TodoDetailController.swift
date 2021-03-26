//
//  TodoDetailController.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//

import UIKit

class TodoDetailController: UIViewController {
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var completedBtn: UIButton!
    @IBOutlet var updateBtn: UIButton!
    
    var id: String?
    private var todoData: TaskResponse?
    
    override func viewDidLoad() {
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchDetail()
    }
    
    private func setupView() {
        self.navigationItem.title = "Edit Task"
        self.view.backgroundColor = .orange
        self.navigationController?.navigationBar.barTintColor = .orange
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.descriptionTextField.textColor = .black
        
        self.completedBtn.layer.cornerRadius = 8.0
        self.completedBtn.addTarget(self, action: #selector(self.completedTask), for: .touchUpInside)
        
        self.updateBtn.layer.cornerRadius = 8.0
        self.updateBtn.addTarget(self, action: #selector(self.updateTask), for: .touchUpInside)
    }
    
    private func fetchDetail() {
        TodoService.shared.getTaskById(id: self.id ?? "") { [weak self] fetchResult in
            guard let strongSelf = self else { return }
            switch fetchResult {
            case .success(let response):
                strongSelf.todoData = response.value?.task
                strongSelf.descriptionTextField.text = response.value?.task?.description
            case .failure(let error):
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func updateTask() {
        TodoService.shared.updateTask(id: self.id ?? "", updateValue: self.descriptionTextField.text ?? "", editAction: .update) { [weak self] fetchResult in
            guard let strongSelf = self else { return }
            switch fetchResult {
            case .success(let response):
                strongSelf.navigationController?.popViewController(animated: true)
            case .failure(let error):
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func completedTask() {
        TodoService.shared.updateTask(id: self.id ?? "", editAction: .completed) { [weak self] fetchResult in
            guard let strongSelf = self else { return }
            switch fetchResult {
            case .success(let response):
                strongSelf.navigationController?.popViewController(animated: true)
            case .failure(let error):
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
}
