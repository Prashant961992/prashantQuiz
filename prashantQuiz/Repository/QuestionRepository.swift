//
//  QuestionRepository.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit
import FMDB

/**
 The QuestionRepository class provides methods to retrieve questions and their choices from a SQLite database.
 */
class QuestionRepository: NSObject {
    
    /**
     Retrieves 10 random questions from the database and returns them as an array of Question objects. This method takes a closure as a parameter which is called asynchronously when the data is retrieved.
     
     - Parameters:
         - result: A closure that is called once the operation is completed. It takes an optional array of `Question` objects and an optional `Error` object as parameters.
     */
    func getQuestions(result : @escaping (_ value: [Question]?, _ error: Error?) -> Void)  {
        let database = FMDatabase(url: AppManager.instance.getDirectoryPath())
        var arrayOfQuestions = [Question]()
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        do {
            let query = "SELECT * FROM questions ORDER BY RANDOM() LIMIT 10;"
            let results = try database.executeQuery(query, values: nil)
            while results.next() {
                let questionId = results.int(forColumn: "question_id")
                guard let questionText = results.string(forColumn: "question_text") else { return }
                
                let question = Question(questionId: Int(questionId), questionText: questionText , questionScore: 0, isCorrect: false, selectedOptionId: 0)
                arrayOfQuestions.append(question)
            }
            result(arrayOfQuestions, nil)
        } catch {
            result(arrayOfQuestions, "Error inserting initial data: \(error)" as? Error)
        }
        
        database.close()
    }
    
    /**
     The getQuestionChoices function retrieves 3 random options associated with a specific question, shuffles the array of options and then creates an array of QuestionOption objects.
     
     - Parameters:
        - questionid: The ID of the question for which options need to be retrieved.
        - result: A completion handler which is called when the options are retrieved successfully or when an error occurs.
        - value: An array of QuestionOption objects representing the retrieved options. Can be nil if an error occurs.
        - error: An Error object containing details about the error that occurred, if any. Can be nil if the options are retrieved successfully.
     */
    func getQuestionChoices(questionid: Int, result : @escaping (_ value: [QuestionOption]?, _ error: Error?) -> Void) {
        let database = FMDatabase(url: AppManager.instance.getDirectoryPath())
        var arrayOfOptions = [QuestionOption]()
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        do {
            let query = "SELECT option_id,option_text, is_correct FROM ( SELECT * FROM options WHERE question_id = \(questionid) ORDER BY RANDOM() LIMIT 4 ) AS temp ORDER BY is_correct DESC LIMIT 3;"
            let results = try database.executeQuery(query, values: nil)
            while results.next() {
                let optionId = results.int(forColumn: "option_id")
                guard let optionText = results.string(forColumn: "option_text") else { return }
                let isCorrect = results.int(forColumn: "is_correct")
                
                let question = QuestionOption(optionId: Int(optionId), optionText: optionText, isCorrect: Int(isCorrect))
                arrayOfOptions.append(question)
            }
            arrayOfOptions.shuffle()
            result(arrayOfOptions, nil)
        } catch {
            result(arrayOfOptions, "Error inserting initial data: \(error)" as? Error)
        }
        
        database.close()
    }
}
