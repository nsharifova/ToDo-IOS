//
//  ViewController.swift
//  ToDo-App
//
//  Created by Nurluay Sharifova on 01.10.24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.getUserList()
        viewModel.success = {
            self.tableView.reloadData()
        }
        viewModel.error = { message in
            self.showAlert(title: "Error", message: message)
        }
        
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: "CustomTableCell")
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CreateUserViewController") as! CreateUserViewController
        controller.completion = { [weak self] in
            self?.viewModel.getUserList()
        }
        navigationController?.show(controller, sender: nil)
    }
}

//MARK: Tableview configs
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableCell
        cell.configure(data: viewModel.users[indexPath.row])
        
        
        cell.deleteUserAction = { [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteUser(indexPath: indexPath)
        }
        cell.editUserAction = { [weak self] in
            guard let self = self else { return }
            self.editUser(at: indexPath)
        }
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
}

//MARK: CoreData configs
extension ViewController {
    
    
    func editUser(at indexPath : IndexPath) {
        let alertController = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
        let userData = viewModel.users[indexPath.row]
        
        alertController.addTextField { textField in
            textField.placeholder = "Firstname"
            textField.text = userData.firstname
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Lastname"
            textField.text = userData.lastname
            
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            guard let firstname = alertController.textFields?[0].text, !firstname.isEmpty,
                  let lastname = alertController.textFields?[1].text, !lastname.isEmpty else {
                
                self.showAlert(title: "Error", message: "Please fill the fields",okButtonTitle:"OK")
                return
                
            }
            self.viewModel.editUser(indexPath: indexPath, firstName: firstname, lastName: lastname)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
