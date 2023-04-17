//
//  ThankYouViewController.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit

class ThankYouViewController: BaseViewController {
    @IBOutlet weak var lblMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func actionPlayAgain(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
