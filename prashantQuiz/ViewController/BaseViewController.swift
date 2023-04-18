//
//  BaseViewController.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit
import KRProgressHUD

protocol BaseViewControllerProtocol {
    func createViewModelBinding()
    func createCallbacks()
}

class BaseViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showSnackbar(_ message : String) {
        //        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        //
        //        let okAction = UIAlertAction(title: "OK", style: .default) { action in
        //
        //        }
        //        alertController.addAction(okAction)
        //        present(alertController, animated: true, completion: nil)
    }
    
    func showHud(message : String = "Please wait...")  {
        KRProgressHUD.set(style: .custom(background: .black, text: .white, icon: nil)).show(withMessage: message)
    }
    
    func hideHud() {
        KRProgressHUD.dismiss()
    }
}
