//
//  CustomTableCell.swift
//  ToDo-App
//
//  Created by Nurluay Sharifova on 03.10.24.
//

import CoreData
import UIKit

class CustomTableCell: UITableViewCell {
    var deleteUserAction: (() -> Void)?
    var editUserAction: (() -> Void)?
    
    private let userName: UILabel = {
        let name = UILabel()
        name.textColor = .black
        name.textAlignment = .left
        return name
    }()
    
    
    @objc private func deleteButtonClicked() {
        deleteUserAction?()
        
    }
    
    @objc private func editButtonClicked() {
        editUserAction?()
        
    }
    
    private let deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "trash"), for: .normal)
        btn.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        btn.tintColor = .red
        return btn
    }()
    
    private let editButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "pencil"), for: .normal)
        btn.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    func configure(data: UserData) {
        userName.text = "\(data.firstname) \(data.lastname)"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(userName)
        addSubview(deleteButton)
        addSubview(editButton)
        userName.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            userName.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            userName.centerYAnchor.constraint(equalTo: centerYAnchor),
            userName.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -16),
            
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor,constant: -10)
            
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    
}

