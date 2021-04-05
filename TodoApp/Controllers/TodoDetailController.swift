//
//  TodoDetailController.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//

import UIKit

class TodoDetailController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet var descriptionTextField: UITextField! {
        didSet {
            self.descriptionTextField.textColor = .black
        }
    }

    @IBOutlet var completedBtn: UIButton! {
        didSet {
            self.completedBtn.layer.cornerRadius = 8.0
            self.completedBtn.addTarget(self, action: #selector(self.completedTask), for: .touchUpInside)
        }
    }

    @IBOutlet var updateBtn: UIButton! {
        didSet {
            self.updateBtn.layer.cornerRadius = 8.0
            self.updateBtn.addTarget(self, action: #selector(self.updateTask), for: .touchUpInside)
        }
    }
    
    // MARK: - Properties
    
    var id: String!
    private var todoData: TaskResponse?
    private var oTask: TaskManagementViewModel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        self.oTask = TaskManagementViewModel()
        self.oTask.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchDetail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupView()
    }
    
    // MARK: - UI Setup
    
    private func setupView() {
        self.navigationItem.title = "Edit Task"
        self.view.backgroundColor = .orange
        self.navigationController?.navigationBar.barTintColor = .orange
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: - Private Methods
    
    private func fetchDetail() {
        self.oTask.getTaskById(id: self.id)
    }
    
    @objc internal func updateTask() {
        self.oTask.updateTask(id: self.id, updateValue: self.descriptionTextField.text ?? "", action: .update)
    }
    
    @objc private func completedTask() {
        self.oTask.updateTask(id: self.id, updateValue: "", action: .completed)
    }
}

extension TodoDetailController: TaskManagementViewModelDelegate {
    func getTaskById(data: TaskResponse) {
        self.todoData = data
        self.descriptionTextField.text = data.description
    }
    
    func getTaskByIdFail(error: Error) {
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateTaskSuccess(action: EditAction) {
        let message = action == .completed ? "This task is completed" : "Update Success"
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateTaskFail(error: Error) {
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
