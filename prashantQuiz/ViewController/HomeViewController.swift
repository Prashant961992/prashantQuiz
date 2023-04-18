//
//  HomeViewController.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit
import RxSwift
import RxCocoa

/**
 The HomeViewController class is responsible for handling the home screen of the application. It inherits from BaseViewController, which provides some basic functionality such as showing a loading spinner and displaying error messages.
 */
class HomeViewController: BaseViewController {
    @IBOutlet weak var btnPlayGame: UIButton!
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hiding the navigation bar
        self.navigationController?.navigationBar.isHidden = true
        
        // Create and bind callbacks for the ViewModel
        createCallbacks()
    }
    
    //    The actionPlayGame method is called when the user taps on the "Play Game" button. It simply calls the getQuestionsData method of the viewModel.
    @IBAction func actionPlayGame(_ sender: Any) {
        self.viewModel.getQuestionsData()
    }
    
    //    The createCallbacks method sets up the callbacks for the viewModel's observables using the bind method from RxSwift.
    func createCallbacks() {
        viewModel.isSuccess.asObservable()
            .bind{ value in
                if value{
                    
                }
            }.disposed(by: disposeBag)
        
        viewModel.errorMsg.asObservable()
            .bind { errorMessage in
                if errorMessage.count > 0 {
                    self.showSnackbar(errorMessage)
                }
            }.disposed(by: disposeBag)
        
        viewModel.isLoading.asObservable()
            .bind { value in
                if value {
                    self.showHud()
                } else {
                    self.hideHud()
                }
            }.disposed(by: disposeBag)
        
        viewModel.model.questionsData.asObservable()
            .bind{ value in
                if value.count > 0 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
                    vc.questions = value
                    vc.currentQuestion = 0
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.viewModel.errorMsg.accept("Fail to get question data")
                }
            }.disposed(by: disposeBag)
    }
}
