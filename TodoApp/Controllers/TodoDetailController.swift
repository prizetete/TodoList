//
//  TodoDetailController.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//

import UIKit

class TodoDetailController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var completedBtn: UIButton!
    @IBOutlet var updateBtn: UIButton!
    
    // MARK: - Properties

    var id: String?
    private var todoData: TaskResponse?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchDetail()
    }
    
    // MARK: - UI Setup

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
    
    // MARK: - Private Methods

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
    
    @objc private func updateTask() {
        TodoService.shared.updateTask(id: self.id ?? "", updateValue: self.descriptionTextField.text ?? "", editAction: .update) { [weak self] fetchResult in
            guard let strongSelf = self else { return }
            switch fetchResult {
            case .success:
                let alert = UIAlertController(title: "Alert", message: "Update Success", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    strongSelf.navigationController?.popViewController(animated: true)
                }))
                strongSelf.present(alert, animated: true, completion: nil)
            case .failure(let error):
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func completedTask() {
        TodoService.shared.updateTask(id: self.id ?? "", editAction: .completed) { [weak self] fetchResult in
            guard let strongSelf = self else { return }
            switch fetchResult {
            case .success:
                let alert = UIAlertController(title: "Alert", message: "This task is completed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    strongSelf.navigationController?.popViewController(animated: true)
                }))
                strongSelf.present(alert, animated: true, completion: nil)
            case .failure(let error):
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
}
