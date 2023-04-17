//
//  QuestionViewController.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit
import RxSwift
import RxCocoa


class QuestionViewController: BaseViewController {
    var questions = [Question]()
    var currentQuestion : Int = 1
    var timer = Timer()
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblSequence: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    let viewModel = QuizViewModel()
    let disposeBag = DisposeBag()
    @IBOutlet weak var tblViewQuestions: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewQuestions.estimatedRowHeight = 44
        lblScore.text = "\(viewModel.calculateTotalScore(questions: questions))"
        self.createCallbacks()
        self.viewModel.getQuestionChoicesData(questionId: questions[currentQuestion].questionId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblSequence.text = "\(currentQuestion + 1)"
        self.startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if viewModel.timeLeft > 0 {
            viewModel.timeLeft -= 1
            print("Time left: \(viewModel.timeLeft)")
            lblTimer.text = "\(viewModel.timeLeft)"
            if viewModel.timeLeft == 0 {
                self.redirectScreen()
            }
        } else {
            timer.invalidate()
            print("Time's up!")
        }
    }
    
    func redirectScreen() {
        timer.invalidate()
        let updatesQuestions = viewModel.getUpdatedScoreArray(selectedQuestion: viewModel.selectedQuestion, currentIndex: currentQuestion, questions: questions)
        if (currentQuestion + 1) == 10 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouViewController") as! ThankYouViewController
            vc.questions = updatesQuestions
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
            vc.questions = updatesQuestions
            vc.currentQuestion = currentQuestion + 1
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        
        viewModel.model.optionsData.asObservable()
            .bind{ value in
                if value.count > 0 {
                    self.viewModel.questionsOptions = value
                    self.tblViewQuestions.reloadData()
                } else {
                    self.viewModel.errorMsg.accept("Fail to get question options")
                }
            }.disposed(by: disposeBag)
    }
    
    @IBAction func actionNextClick(_ sender: Any) {
        if viewModel.selectedQuestion == nil {
            let alertController = UIAlertController(title: "Error", message: "Please select option", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            self.redirectScreen()
        }
    }
    
}

extension QuestionViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.questionsOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
            cell.selectionStyle = .none
            cell.lblQuestions.text = questions[currentQuestion].questionText
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCellSelection", for: indexPath) as! QuestionTableViewCell
            
            if viewModel.questionsOptions[indexPath.row].optionId == viewModel.selectedQuestion?.optionId {
                cell.imgSelection.image = UIImage(named: "fillRadio")
            } else {
                cell.imgSelection.image = UIImage(named: "emptyRadio")
            }
            
            let selectedView = UIView()
            selectedView.backgroundColor = .clear
            cell.selectedBackgroundView = selectedView
            
            cell.lblQuestions.text = viewModel.questionsOptions[indexPath.row].optionText
            return cell
        }
    }
}

extension QuestionViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            viewModel.lastAnswerSelectedSecond = (20 - viewModel.timeLeft)
            viewModel.selectedQuestion = viewModel.questionsOptions[indexPath.row]
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }
}
