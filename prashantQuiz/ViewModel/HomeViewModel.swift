//
//  HomeViewModel.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit

class HomeViewModel: BaseViewModel {
    let model : QuestionModel = QuestionModel()

    func getQuestionsData() {
        self.isLoading.accept(true)
        
        let ws = QuestionRepository()
      
        ws.getQuestions { response, error in
            if response != nil {
                self.model.questionsData.accept(response ?? [Question]())
                self.isSuccess.accept(true)
            } else if error != nil {
                self.isSuccess.accept(false)
                self.errorMsg.accept( error?.localizedDescription ?? "")
            }
            self.isLoading.accept(false)
        }
    }
}
