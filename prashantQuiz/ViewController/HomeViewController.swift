//
//  HomeViewController.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
    @IBOutlet weak var btnPlayGame: UIButton!
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        createCallbacks()
    }
    
    @IBAction func actionPlayGame(_ sender: Any) {
        self.viewModel.getQuestionsData()
    }
    
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
