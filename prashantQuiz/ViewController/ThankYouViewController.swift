//
//  ThankYouViewController.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit

/**
 The ThankYouViewController that inherits from BaseViewController
 */
class ThankYouViewController: BaseViewController {
    
    var questions = [Question]()
    let viewModel = QuizViewModel()
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To the result of calling the calculateTotalScore method of viewModel, passing in the questions array.
        lblScore.text = "Your score is: \(viewModel.calculateTotalScore(questions: questions))"
        
        // To the result of calling the getResultMessage method of viewModel, also passing in the questions array.
        lblMessage.text = viewModel.getResultMessage(questions: questions)
    }
    
    //  Method named actionPlayAgain, which is called when the user taps a "Play Again" button.
    @IBAction func actionPlayAgain(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
