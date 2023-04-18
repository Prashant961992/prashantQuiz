//
//  QuestionViewController.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit
import RxSwift
import RxCocoa

/**
 The QuestionViewController class is responsible for handling the question screen of the application. It inherits from BaseViewController, which provides some basic functionality such as showing a loading spinner and displaying error messages.
 */
class QuestionViewController: BaseViewController {
    
    var questions = [Question]()
    var currentQuestion : Int = 1
    var timer = Timer()
    let viewModel = QuizViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblSequence: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var tblViewQuestions: UITableView!
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set estimated row height for the table view
        tblViewQuestions.estimatedRowHeight = 44
        
        // Calculate and display the total score
        lblScore.text = "\(viewModel.calculateTotalScore(questions: questions))"
        
        // Create and bind callbacks for the ViewModel
        self.createCallbacks()
        
        // Get the options data for the current question from the ViewModel
        self.viewModel.getQuestionChoicesData(questionId: questions[currentQuestion].questionId)
    }
    
    // Lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set corner radius and shadow properties for the table view
        self.tblViewQuestions.layer.cornerRadius = 10.0
        self.tblViewQuestions.clipsToBounds = true
        self.tblViewQuestions.layer.shadowColor = UIColor.black.cgColor
        self.tblViewQuestions.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.tblViewQuestions.layer.shadowOpacity = 0.8
        self.tblViewQuestions.layer.shadowRadius = 5
        self.tblViewQuestions.layer.masksToBounds = false
        
        // Update the question number label
        lblSequence.text = "\(currentQuestion + 1)"
        
        // Start the timer
        self.startTimer()
    }
    
    // Start the timer
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // Update the timer
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
    
    // Redirect to the next screen
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
    
    /**
    This function applies a circular radius and border to the background view of a QuestionTableViewCell.

    - Parameters:
     - cell: The QuestionTableViewCell object whose background view needs to be styled.
     - backgroundColor: The color to be applied to the background view of the cell.
     - borderColor: The color to be applied to the border of the background view of the cell.
    */
    func optionViewRadiusAndWidthSelection(cell: QuestionTableViewCell, backgroundColor: UIColor, borderColor: UIColor) {
        cell.viewCellBackground.backgroundColor = backgroundColor
        cell.viewCellBackground.layer.cornerRadius = 10.0
        cell.viewCellBackground.layer.borderColor = borderColor.cgColor
        cell.viewCellBackground.layer.borderWidth = 1.0
        cell.viewCellBackground.clipsToBounds = true
    }
}

// MARK: - UI TableView DataSource
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
                cell.imgSelection.isHidden = false
                if viewModel.questionsOptions[indexPath.row].isCorrect == 1 {
                    cell.imgSelection.image = UIImage(named: "right")
                    optionViewRadiusAndWidthSelection(cell: cell, backgroundColor: UIColor(named: "green")!.withAlphaComponent(0.5), borderColor: UIColor(named: "green")!)
                } else {
                    cell.imgSelection.image = UIImage(named: "wrong")
                    optionViewRadiusAndWidthSelection(cell: cell, backgroundColor: UIColor(named: "red")!.withAlphaComponent(0.5), borderColor: UIColor(named: "red")!)
                }
            } else {
                cell.imgSelection.isHidden = true
                optionViewRadiusAndWidthSelection(cell: cell, backgroundColor: UIColor.white, borderColor: UIColor.black)
            }
            
            
            
            let selectedView = UIView()
            selectedView.backgroundColor = .clear
            cell.selectedBackgroundView = selectedView
            
            cell.lblQuestions.text = viewModel.questionsOptions[indexPath.row].optionText
            return cell
        }
    }
}

// MARK: - UI TableView Delegate
extension QuestionViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            viewModel.lastAnswerSelectedSecond = (20 - viewModel.timeLeft)
            viewModel.selectedQuestion = viewModel.questionsOptions[indexPath.row]
            tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.redirectScreen()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 80
        }
    }
}
