//
//  UIViewController+Category.swift
//  HomePlus
//
//  Created by liujinliang on 2017/4/26.
//  Copyright © 2017年 worldunion. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    // 从nib中加载
    static func initFromNib() -> Self {
        let hasNib: Bool = Bundle.main.path(forResource: self.nameOfClass, ofType: "nib") != nil
        guard hasNib else {
            assert(!hasNib, "Invalid parameter") // here
            return self.init()
        }
        return self.init(nibName: self.nameOfClass, bundle: nil)
    }
    
}

extension  UIViewController {
    
    
    func displayAlertControllerWithMessage(_ message: String, closure: (() -> Void)? = nil) {
        displayAlertController(nil, message: message, actions: closure == nil ? nil : [UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
            closure?()
        })])
    }
    
    func displayAlertControllerWithMessageAndTitle(_ title:String, message: String, closure: (() -> Void)? = nil) {
        displayAlertController(title, message: message, actions: closure == nil ? nil : [UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
            closure?()
        })])
    }
    
    
    /**
     Display alert controler with given message and actions
     
     - Parameter message: the message to display
     - Parameter actions: the actiosn of alert controller
     */
    func displayAlertController(_ message: String, actions: [UIAlertAction]) {
        displayAlertController(nil, message: message, actions: actions)
    }
    
    /**
     Display alert controller with given title, message and actions
     
     - Parameter title:   the title of the alert controller
     - Parameter message: the message to display
     - Parameter actions: the actions of alert controller
     */
    func displayAlertController(_ title: String?, message: String?, actions: [UIAlertAction]?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            for action in actions {
                alertController.addAction(action)
            }
        } else {
            // Default cancel action
            alertController.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        }
        present(alertController, animated: true, completion: nil)
    }
    
}
