//
//  HomeViewModel.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit

/**
A view model that manages the data and behavior for the quiz feature of the app. It inherits from `BaseViewModel` class and may add additional functionality or override inherited methods as needed.
 */
class HomeViewModel: BaseViewModel {
    let model : QuestionModel = QuestionModel()
    
    /**
     This function retrieves the questions data from the database via the QuestionRepository. It sets the isLoading variable to true to show the user that the data is being loaded. If the data is successfully retrieved from the database, it sets the questionsData variable of the viewModel to the retrieved data and sets the isSuccess variable to true. If there is an error, it sets the isSuccess variable to false and sets the errorMsg variable to the error message. Finally, it sets the isLoading variable to false to indicate that the loading has finished.
     */
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
