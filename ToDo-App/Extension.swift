//
//  Extension.swift
//  ToDo-App
//
//  Created by Samxal Quliyev  on 10.10.24.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, 
                   message: String,
                   okButtonTitle: String = "OK") {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)        
        let okAction = UIAlertAction(title: okButtonTitle, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
