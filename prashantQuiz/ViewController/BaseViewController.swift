//
//  BaseViewController.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit
import KRProgressHUD

/**
 The BaseViewControllerProtocol protocol defines two required methods that any view controller conforming to this protocol must implement.
 */
protocol BaseViewControllerProtocol {
    func createViewModelBinding()
    func createCallbacks()
}

/**
 The BaseViewController class is a subclass of UIViewController and serves as a base class for other view controllers to inherit from. It provides some common functionality that can be used across multiple view controllers
 */
class BaseViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate // An instance of the app's AppDelegate class.
    
    /**
     This is an overridden method of the UIViewController class that is called when the view controller's view is loaded into memory. It disables the interactive pop gesture recognizer of the navigation controller to prevent unexpected popping of the view controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // This is an overridden method of the UIViewController class that is called when the app receives a memory warning. It is not implemented in this class.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // This method takes a message string as input and shows a snackbar alert with the message.
    func showSnackbar(_ message : String) {
    }
    
    // This method takes an optional message string as input and shows a loading indicator with the message using the KRProgressHUD library.
    func showHud(message : String = "Please wait...")  {
        KRProgressHUD.set(style: .custom(background: .black, text: .white, icon: nil)).show(withMessage: message)
    }
    
    
    // This method hides the loading indicator shown by showHud(message:).
    func hideHud() {
        KRProgressHUD.dismiss()
    }
}
