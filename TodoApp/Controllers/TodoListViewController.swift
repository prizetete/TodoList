//
//  TodoListViewController.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//
import UIKit

class TodoListViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties

    private var todoData: [TaskResponse] = []
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchDataTodoTask()
    }
    
    // MARK: - UI Setup

    private func setupView() {
        self.navigationItem.title = "To Do"
        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = .orange
        self.navigationController?.navigationBar.barTintColor = .orange
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
        
        let rightBtn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout))
        rightBtn.tintColor = .white
        let rightBtn2 = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.fetchDataTodoTask))
        rightBtn2.tintColor = .white
        self.navigationItem.rightBarButtonItems = [rightBtn, rightBtn2]
        
        let leftBtn = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.addTodoTask))
        leftBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = leftBtn
    }
    
    // MARK: - Private Methods

    @objc private func fetchDataTodoTask() {
        TodoService.shared.getAllTask { [weak self] fetchResult in
            guard let strongSelf = self else { return }
            switch fetchResult {
            case .success(let response):
                strongSelf.todoData = response.value?.task ?? []
                strongSelf.tableView.reloadData()
            case .failure(let error):
                let alert = UIAlertController(title: "Alert Error From API", message: "\(error)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func addTodoTask() {
        let alert = UIAlertController(title: "Alert", message: "Add todo task", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            TodoService.shared.addTodoTask(description: textField?.text ?? "") { [weak self] fetchResult in
                guard let strongSelf = self else { return }
                switch fetchResult {
                case .success:
                    strongSelf.fetchDataTodoTask()
                case .failure(let error):
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func logout() {
        let alertController = UIAlertController(title: "Alert", message: "Do you want to logout?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            TodoService.shared.logout { [weak self] fetchResult in
                guard let strongSelf = self else { return }
                switch fetchResult {
                case .success(let response):
                    if response.value?.status ?? false {
                        UserProfileManager.removeUserDefault()
                        UserProfileManager.setUserLoginState(isLogin: false)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewControllerID") as! LoginViewController
                        let navigationController = UINavigationController(rootViewController: viewController)
                        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController = navigationController
                        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.makeKeyAndVisible()
                    }
                case .failure(let error):
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.todoData.count > 0 {
            let data = self.todoData[indexPath.row]
            if !(data.completed ?? false) {
                let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TodoDetailControllerID") as! TodoDetailController
                destinationVC.id = data._id
                self.navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.todoData[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "todoCell") as! TodoCell
        cell.backgroundColor = data.completed ?? false ? .green : .white
        cell.todoDescriptionLabel.text = data.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return self.todoData.count > 0 ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, self.todoData.count > 0 {
            let data = self.todoData[indexPath.row]
            TodoService.shared.removeTask(id: data._id ?? "") { [weak self] fetchResult in
                guard let strongSelf = self else { return }
                switch fetchResult {
                case .success:
                    strongSelf.todoData.remove(at: indexPath.row)
                    strongSelf.tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
