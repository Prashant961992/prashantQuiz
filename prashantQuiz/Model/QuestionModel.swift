//
//  QuestionModel.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import Foundation

import RxSwift
import RxCocoa

class QuestionModel : BaseViewModel {
    var questionsData : BehaviorRelay<[Question]> = BehaviorRelay(value: [Question]())
    var optionsData : BehaviorRelay<[QuestionOption]> = BehaviorRelay(value: [QuestionOption]())
}

class Question: Codable {
    var questionId: Int
    var questionText: String
    var questionScore: Int
    var isCorrect: Bool
    var selectedOptionId: Int
    
    init(questionId: Int, questionText: String, questionScore: Int, isCorrect: Bool, selectedOptionId: Int) {
        self.questionId = questionId
        self.questionText = questionText
        self.questionScore = questionScore
        self.isCorrect = isCorrect
        self.selectedOptionId = selectedOptionId
    }
}

class QuestionOption: Codable {
    var optionId: Int
    var optionText: String
    var isCorrect: Int
    
    init(optionId: Int, optionText: String, isCorrect: Int) {
        self.optionId = optionId
        self.optionText = optionText
        self.isCorrect = isCorrect
    }
}
