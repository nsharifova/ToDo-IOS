//
//  ViewController.swift
//  ToDo-App
//
//  Created by Nurluay Sharifova on 01.10.24.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var users = [UserData]()
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newUser"), object: nil)
        
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: "CustomTableCell")
        
    }
    @objc func getData () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        do {
            let results = try context.fetch(fetchData) as! [NSManagedObject]
            users = results.compactMap { user in
                guard let firstname = user.value(forKey: "firstname") as? String,
                      let lastname = user.value(forKey: "lastname") as? String,
                      let id = user.value(forKey: "id") as? UUID else { return nil }
                return UserData(firstname: firstname, lastname: lastname, id: id)
            }
            
            tableView.reloadData()
            
        }
        catch {
            print(error)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableCell
        cell.configure(data: users[indexPath.row])
        
        //burda weak self falan hec basa dushmedim hardansa goturdum ishlesin deye ))
        cell.deleteUserAction = { [weak self] in
            guard let self = self else { return }
            self.deleteUser(at: indexPath)
        }
        cell.editUserAction = { [weak self] in
            guard let self = self else { return }
            self.editUser(at: indexPath)
        }
        cell.contentView.isUserInteractionEnabled = false
        
        
        return cell
    }
    func deleteUser(at indexPath: IndexPath) {
        let userData = users[indexPath.row]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "id == %@", userData.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let user = results.first {
                context.delete(user)
                try context.save()
                users.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } catch {
            print("error")
        }
    }
    
    func editUser(at indexPath : IndexPath) {
        let alertController = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
        let userData = users[indexPath.row]
        
        alertController.addTextField { textField in
            textField.placeholder = "Firstname"
            textField.text = userData.firstname
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Lastname"
            textField.text = userData.lastname
            
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            guard alertController.textFields?[0].text != nil && alertController.textFields?[1].text != nil else {
                let errorAlert = UIAlertController(title: "Error", message: "Firstname and Lastname cannot be empty.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(errorAlert, animated: true)
                return
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
            fetchRequest.predicate = NSPredicate(format: "id == %@", userData.id as CVarArg)
            
            do {
                let results = try context.fetch(fetchRequest)
                if let user = results.first {
                    user.setValue(alertController.textFields?[0].text, forKey: "firstname")
                    user.setValue(alertController.textFields?[1].text, forKey: "lastname")
                }
                try context.save()
                self.getData()
                
            } catch {
                print("error")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
}

