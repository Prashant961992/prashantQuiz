//
//  BaseViewModel.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewModel: NSObject {
    let disposebag = DisposeBag()
    // Fields that bind to our view's
    let isSuccess : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let isLoading : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let errorMsg : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
}
