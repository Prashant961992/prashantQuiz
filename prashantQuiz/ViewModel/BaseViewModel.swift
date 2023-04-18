//
//  BaseViewModel.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit
import RxSwift
import RxCocoa

/**
 This is a class called BaseViewModel which is a subclass of NSObject. It likely serves as a base class for other view model classes and provides common functionality and properties that are needed in view model classes.
 */
class BaseViewModel: NSObject {
    let disposebag = DisposeBag()
    // Fields that bind to our view's
    let isSuccess : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let isLoading : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let errorMsg : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
}
