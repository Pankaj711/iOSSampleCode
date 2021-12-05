//
//  AlertDisplayer.swift
//  Test
//
//  Test Project
//

import Foundation
import UIKit

// MARK: - ALERT DISPALYER PROTOCOL
protocol AlertDisplayer {
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]?)
}

// MARK: - ALERT DISPLAYER EXTENSION
extension AlertDisplayer where Self: UIViewController {
    // MARK: - DISPLAY ALERT METHOD DEFAULT IMPLEMENTATION
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
        guard presentedViewController == nil else {
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions?.forEach { action in
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
}
