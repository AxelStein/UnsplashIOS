//
//  Ext.swift
//  Unsplash
//
//  Created by Александр Шерий on 04.09.2022.
//

import UIKit

extension UIViewController {
    
    func showSnackbar(message: String) {
        let snackbar = UIView()
        snackbar.backgroundColor = .darkGray
        snackbar.translatesAutoresizingMaskIntoConstraints = false
        snackbar.layer.cornerRadius = 4
        view.addSubview(snackbar)
        
        let label = UILabel()
        label.text = message
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        snackbar.addSubview(label)
        
        view.addConstraints([
            snackbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            snackbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            snackbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
        ])
        view.addConstraints([
            label.leadingAnchor.constraint(equalTo: snackbar.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: snackbar.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: snackbar.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: snackbar.bottomAnchor, constant: -16),
        ])
        
        let deadline = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            snackbar.removeFromSuperview()
        }
    }
}
