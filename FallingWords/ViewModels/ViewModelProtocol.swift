//
//  ViewModelProtocol.swift
//  FallingWords
//
//  Created by Reshma Unnikrishnan on 10.09.18.
//  Copyright © 2018 babbel. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ViewState {}

class ViewStateNull: ViewState {
    static let sharedInstance = ViewStateNull()
}

protocol ViewModelProtocol: class {
    func execute(command:Any, data:AnyObject?) -> Void;
    
    func getViewState() -> ViewState;
    func setViewState(viewstate: ViewState) -> Void;
    var viewStateStream:PublishSubject<(ViewState, ViewState)> {get}
}
