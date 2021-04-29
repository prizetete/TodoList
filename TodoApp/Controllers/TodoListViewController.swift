//
//  TodoListViewController.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//
import UIKit
import RxCocoa
import RxSwift

class TodoListViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.backgroundColor = .white
            self.tableView.separatorStyle = .none
        }
    }
    
    // MARK: - Properties

    private var todoData: [TaskResponse] = []
    private var rxTodoData = PublishSubject<[TaskResponse]>()
    private var oUserAction: UserActionViewModel!
    private var oTask: TaskManagementViewModel!
    private var bag = DisposeBag()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        self.oUserAction = UserActionViewModel()
        self.oUserAction.delegate = self
        
        self.oTask = TaskManagementViewModel()
        self.oTask.delegate = self
        
        self.bindTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchDataTodoTask()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupView()
    }
    
    // MARK: - UI Setup

    private func bindTableView() {
        rxTodoData.bind(to: self.tableView.rx.items(cellIdentifier: "todoCell", cellType: TodoCell.self)) { (row, item, cell) in
            cell.todoDescriptionLabel.text = item.description
            cell.backgroundColor = item.completed ?? false ? .green : .white
        }.disposed(by: bag)
        
        self.tableView.rx.modelSelected(TaskResponse.self).subscribe(onNext: { data in
            if !(data.completed ?? false) {
                let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TodoDetailControllerID") as! TodoDetailController
                destinationVC.id = data._id
                self.navigationController?.pushViewController(destinationVC, animated: true)
            }
        }).disposed(by: bag)
        
        self.tableView.rx.itemDeleted.subscribe(onNext: {
            print("idx: \($0)")
        }).disposed(by: bag)
    }
    
    private func removeItem() {
        
        
    }
    
    private func setupView() {
        self.navigationItem.title = "To Do"
        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = .orange
        self.navigationController?.navigationBar.barTintColor = .orange
        self.navigationController?.navigationBar.isTranslucent = false
        
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
        self.oTask.getAllTask()
    }
    
    @objc private func addTodoTask() {
        let alert = UIAlertController(title: "Alert", message: "Add todo task", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.oTask.addNewTask(descp: textField?.text ?? "")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func logout() {
        let alertController = UIAlertController(title: "Alert", message: "Do you want to logout?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.oUserAction.logout()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}

extension TodoListViewController: UserActionViewModelDelegate {
    func logoutSuccess(data: LogoutResponse) {
        if data.status ?? false {
            UserProfileManager.removeUserDefault()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewControllerID") as! LoginViewController
            let navigationController = UINavigationController(rootViewController: viewController)
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController = navigationController
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.makeKeyAndVisible()
        }
    }
    
    func logoutFail(error: Error) {
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension TodoListViewController: TaskManagementViewModelDelegate {
    func getAllTask(data: [TaskResponse]) {
        rxTodoData.onNext(data)
    }
    
    func getAllTaskFail(error: Error) {
        let alert = UIAlertController(title: "Alert Error From API", message: "\(error)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func addNewTask() {
        self.fetchDataTodoTask()
    }
    
    func addNewTaskFail(error: Error) {
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeTaskSuccess(idxPath: IndexPath) {
        self.todoData.remove(at: idxPath.row)
        self.tableView.deleteRows(at: [idxPath], with: .fade)
    }
    
    func removeTaskFail(error: Error) {
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
