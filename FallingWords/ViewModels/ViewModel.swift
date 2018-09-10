//
//  ViewModel.swift
//  FallingWords
//
//  Created by Reshma Unnikrishnan on 10.09.18.
//  Copyright © 2018 babbel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel<T>: ViewModelProtocol {
    var viewStateStream = PublishSubject<(ViewState, ViewState)>()
    private var _oldState: T?
    
    var viewState:T?  {
        willSet(newState) {
            _oldState = self.viewState
        }
        didSet {
            if (_oldState == nil) {
                viewStateStream.onNext((self.viewState as! ViewState, ViewStateNull.sharedInstance))
            } else {
                viewStateStream.onNext((self.viewState as! ViewState, _oldState as! ViewState))
            }
        }
    }
    
    func execute(command:Any, data:AnyObject? = NSNull()) {}
    
    func getViewState() -> ViewState {
        return viewState! as! ViewState
    }
    
    func setViewState(viewstate: ViewState) {
        self.viewState = viewstate as? T
    }
}
