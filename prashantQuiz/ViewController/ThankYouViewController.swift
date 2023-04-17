//
//  ThankYouViewController.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit

class ThankYouViewController: BaseViewController {
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    var questions = [Question]()
    let viewModel = QuizViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblScore.text = "Your score is: \(viewModel.calculateTotalScore(questions: questions))"
        lblMessage.text = viewModel.getResultMessage(questions: questions)
    }
    
    @IBAction func actionPlayAgain(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
