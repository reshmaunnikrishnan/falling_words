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
    let isDataLoaded: Bool
    
    var currentWordEntry: WordEntry? = nil

    init(isLoading:Bool = false, isDataLoaded:Bool = false) {
        self.isLoading = isLoading
        self.isDataLoaded = isDataLoaded
    }
    
    mutating func setCurrentEntry() {
        let realm = try! Realm()
        
        self.currentWordEntry = realm.objects(WordEntry.self).filter("is_answered == false").first
    }
}

class WordEntryViewModel: ViewModel<WordEntryViewState> {
    internal enum Command:Int {
        case FetchWordEntries = 1
        case FetchQuestion = 2
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
                        self.viewState = WordEntryViewState(isDataLoaded: true)
                    })
                    .disposed(by: bag)
                
                break
            case .FetchQuestion:
                viewState?.setCurrentEntry()
                
                break
            }
        }
    }
    
    func injectWordEntryStore(wordEntryStore:WordEntryStore) -> WordEntryViewModel {
        self.wordEntryStore = wordEntryStore
        return self
    }
}
