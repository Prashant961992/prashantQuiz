//
//  QuizViewModel.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit

/**
A view model that manages the data and behavior for the quiz feature of the app. It inherits from `BaseViewModel` class and may add additional functionality or override inherited methods as needed.
 */
class QuizViewModel: BaseViewModel {
    let model : QuestionModel = QuestionModel()
    var lastAnswerSelectedSecond = 0
    var timeLeft = 20
    var questionsOptions = [QuestionOption]()
    var selectedQuestion : QuestionOption?
    
    /**
    Retrieves a list of question options for the specified question ID.

    - Parameters:
     - questionId: The ID of the question for which to retrieve options.
     
     This function updates the model property of the view model with the retrieved options. If successful, the isSuccess property of the view model is set to true. Otherwise, the isSuccess property is set to false and the errorMsg property is set to the error message.
    */
    func getQuestionChoicesData(questionId: Int) {
        self.isLoading.accept(true)
        let ws = QuestionRepository()
        ws.getQuestionChoices(questionid: questionId, result: { response, error in
            if response != nil {
                self.questionsOptions = response ?? [QuestionOption]()
                self.model.optionsData.accept(response ?? [QuestionOption]())
                self.isSuccess.accept(true)
            } else if error != nil {
                self.isSuccess.accept(false)
                self.errorMsg.accept( error?.localizedDescription ?? "")
            }
            self.isLoading.accept(false)
        })
    }
    
    /**
    This function takes in a selectedQuestion, currentIndex and an array of questions as input and returns an updated array of questions with the current question's score and correctness status updated based on the selectedQuestion.

    - Parameters:
     - selectedQuestion: An optional QuestionOption that represents the option selected by the user.
     - currentIndex: An integer value that represents the index of the current question in the array of questions.
     - questions: An array of Question objects.
     - Returns: An array of Question objects with the score and correctness status of the current question updated based on the selectedQuestion.
    */
    func getUpdatedScoreArray(selectedQuestion: QuestionOption?, currentIndex: Int, questions: [Question]) -> [Question] {
        var arrayOfquestions = questions
        if selectedQuestion == nil {
            let question = arrayOfquestions[currentIndex]
            question.isCorrect = false
            question.questionScore = 0
            arrayOfquestions.remove(at: currentIndex)
            arrayOfquestions.insert(question, at: currentIndex)
        } else {
            let question = arrayOfquestions[currentIndex]
            let filteredOptions = questionsOptions.filter { $0.isCorrect == 1 }
            if filteredOptions.count > 0 {
                if filteredOptions.first?.optionId == selectedQuestion?.optionId {
                    question.isCorrect = true
                    question.questionScore = calculateScore()
                } else {
                    question.isCorrect = false
                    question.questionScore = 0
                }
            } else {
                question.isCorrect = false
                question.questionScore = 0
            }
            arrayOfquestions.remove(at: currentIndex)
            arrayOfquestions.insert(question, at: currentIndex)
        }
        return arrayOfquestions
    }
    
    /**
     This function calculates the score of a question based on the time it took to answer.
    */
    func calculateScore() -> Int {
        return 10 + (20 - lastAnswerSelectedSecond)
    }
    
    /**
    Calculates the total score of a quiz by summing the scores of individual questions.

    - Parameter questions: An array of `Question` objects representing the questions in the quiz.
    - Returns: An `Int` value representing the total score of the quiz.
    */
    func calculateTotalScore(questions: [Question]) -> Int {
        let sum = questions.reduce(0) { partialResult, question in
            return partialResult + question.questionScore
        }
        return sum
    }
    
    /**
    Calculates the result message based on the scores of the questions.

    Parameter questions: An array of Question objects representing the questions and their scores.
    Returns: A String representing the result message based on the scores of the questions. An empty string if the number of correctly answered questions is not in the above ranges.
    */
    func getResultMessage(questions: [Question]) -> String {
        let filteredOptions = questions.filter { $0.isCorrect == true }
        if filteredOptions.count == 5 {
            return "​You Won!"
        } else if filteredOptions.count == 7 {
            return "​You Won! Congratulations."
        } else if filteredOptions.count == 9 {
            return "​You Won! Congratulations."
        } else if filteredOptions.count == 10 {
            return "​Awesome. You are Genius. Congratulations you won the Game."
        } else if filteredOptions.count == 0 || filteredOptions.count == 1 ||  filteredOptions.count == 2 {
            return "Sorry, You failed."
        } else if filteredOptions.count == 3 || filteredOptions.count == 4 {
            return "Well played but you failed. All The Best for Next Game."
        } else {
            return ""
        }
    }
}
