//
//  QuizViewModel.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit

class QuizViewModel: BaseViewModel {
    let model : QuestionModel = QuestionModel()
    var lastAnswerSelectedSecond = 0
    var timeLeft = 20
    var questionsOptions = [QuestionOption]()
    var selectedQuestion : QuestionOption?
    
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
    
    func calculateScore() -> Int {
        return 10 + (20 - lastAnswerSelectedSecond)
    }
    
    func calculateTotalScore(questions: [Question]) -> Int {
        let sum = questions.reduce(0) { partialResult, question in
            return partialResult + question.questionScore
        }
        return sum
    }
}
