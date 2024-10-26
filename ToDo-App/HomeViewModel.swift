//
//  HomeViewModel.swift
//  ToDo-App
//
//  Created by Samxal Quliyev  on 10.10.24.
//

import Foundation

//MVC: Model-View-Controller
//Model: Struct
//View: Presenter (Cell, UIView, etc)
//Controller: Business Logic handler

//MVVM: Model View View-Model
//Model: Struct
//View: Presenter (UIViewController, Cell, UIView, etc)
//View-Model: Business Logic handler

class HomeViewModel {
    var users = [UserData]()
    let coreDataManager = CoreDataManager()
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func getUserList() {
        coreDataManager.getData { users in
            self.users = users
            success?()
        }
    }
    func deleteUser (indexPath:IndexPath) {
        coreDataManager.deleteUser(id: users[indexPath.row].id) { success , error in
            if success {
                self.users.remove(at: indexPath.row)
                self.success?()
            }
            else {
                self.error?(error ?? "Error")
            }
            
        }
    }
    func editUser(indexPath:IndexPath,firstName:String,lastName:String) {
        coreDataManager.editUser(id: users[indexPath.row].id, firstName: firstName, lastName: lastName) {success,error in
            if success {
                self.users[indexPath.row].firstname = firstName
                self.users[indexPath.row].lastname = lastName
                self.success?()
            } else{
                self.error?(error ?? "Error")
                
            }
            
        }
        
    }
}
