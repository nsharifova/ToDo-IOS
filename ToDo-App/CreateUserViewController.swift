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
    
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if (firstNameLabel.text != ""  && lastnameLabel.text != "") {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newUser = Users(context:context)
            newUser.firstname = firstNameLabel.text
            newUser.lastname = lastnameLabel.text
            newUser.id = UUID()
        
            do {
                try context.save()
                completion?()
                self.navigationController?.popViewController(animated: true)

            }
            catch {
                print("error")
            }
        } else {
          showAlert(title: "Warning", message: "Please fill the fileds")
        }
    }
}
