//
//  QuestionModel.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import Foundation

import RxSwift
import RxCocoa

// This is a Swift class named QuestionModel that inherits from a base class named BaseViewModel.
class QuestionModel : BaseViewModel {
    //    Initialized with an empty array of Question objects, while
    var questionsData : BehaviorRelay<[Question]> = BehaviorRelay(value: [Question]())
    
    //    Initialized with an empty array of QuestionOption objects.
    var optionsData : BehaviorRelay<[QuestionOption]> = BehaviorRelay(value: [QuestionOption]())
}

/**
 A model class that represents a question in a quiz app.
 */
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

/**
 A model class that represents a option for a question in a quiz app.
 */
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
