//
//  WordEntryViewModel.swift
//  FallingWords
//
//  Created by Reshma Unnikrishnan on 10.09.18.
//  Copyright © 2018 babbel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

struct WordEntryViewState: ViewState {
    let isLoading: Bool

    init(isLoading:Bool = false) {
        self.isLoading = isLoading
    }
}

class WordEntryViewModel: ViewModel<WordEntryViewState> {
    internal enum Command:Int {
        case FetchWordEntries = 1
    }

    internal var wordEntryStore:WordEntryStore?
    private let bag = DisposeBag()

    override func execute(command:Any, data:AnyObject? = NSNull()) {
        if let command:Command = command as? Command {
            switch command {
            case .FetchWordEntries:
                
                self.viewState = WordEntryViewState(isLoading: true)
                
                self.wordEntryStore!
                    .fetchWordEntries()
                    .asObservable()
                    .subscribe({ (_) in
                        self.viewState = WordEntryViewState()
                    })
                    .disposed(by: bag)
                
                break
            }
        }
    }
    
    func injectWordEntryStore(wordEntryStore:WordEntryStore) -> WordEntryViewModel {
        self.wordEntryStore = wordEntryStore
        return self
    }
}
