//
//  CreateUserViewController.swift
//  ToDo-App
//
//  Created by Nurluay Sharifova on 01.10.24.
//

import UIKit
import CoreData

class CreateUserViewController: UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var lastnameLabel: UITextField!
    @IBOutlet weak var firstNameLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        if (firstNameLabel.text != ""  && lastnameLabel.text != "") {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
            newUser.setValue(firstNameLabel.text, forKey: "firstname")
            newUser.setValue(lastnameLabel.text, forKey: "lastname")
            newUser.setValue(UUID(), forKey: "id")
            do {
                try context.save()
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name("newUser"), object: nil)
                
                
            }
            catch {
                print("error")
            }
        }
        else {
            let alertController = UIAlertController(title: "Message", message: "Please fill the fields", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            }
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
}
