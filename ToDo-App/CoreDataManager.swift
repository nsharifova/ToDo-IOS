//
//  CoreDataManager.swift
//  ToDo-App
//
//  Created by Samxal Quliyev  on 10.10.24.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var users = [UserData]()
    
    func getData(completion: (([UserData]) -> Void)) {
        do {
            users = try context.fetch(Users.fetchRequest()).map { user in
                UserData(firstname: user.firstname ?? "", lastname: user.lastname ?? "", id: user.id ?? UUID())
            }
            completion(users)
        } catch {
            print(error)
        }
    }
    func deleteUser(id:UUID,completion:((Bool,String?)->Void)){
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            if let user = results.first {
                context.delete(user)
                try context.save()
                completion(true,nil)
            }
        } catch {
            completion(false,"Error")
        }
    }
    
    func editUser(id:UUID,firstName:String,lastName:String,completion:((Bool,String?)->Void)){
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let user = results.first {
                
                user.firstname = firstName
                user.lastname = lastName
            }
            try context.save()
            completion(true,nil)
            
        } catch {
            completion(false,"Error")
        }
    }
    
}
