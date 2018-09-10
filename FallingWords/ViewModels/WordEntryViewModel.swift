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
    
    var isGameOver: Bool
    
    var currentWordEntry: WordEntry? = nil
    var currentWordEntryCorrect: Bool? = nil
    var currentWordEntryDefaulted: Bool? = nil
    
    var totalPoints: Int = 0
    var totalItems: Int = 0

    init(isLoading:Bool = false, isDataLoaded:Bool = false) {
        self.isLoading = isLoading
        self.isDataLoaded = isDataLoaded
        self.isGameOver = false
        
        if self.isDataLoaded {
            let realm = try! Realm()
            
            self.totalItems = realm.objects(WordEntry.self).count
        }
    }
    
    func currentEntryAnswered() -> Bool {
        return self.currentWordEntryCorrect != nil || self.currentWordEntryDefaulted != nil
    }
    
    mutating func setCurrentEntry() {
        let realm = try! Realm()
        
        self.currentWordEntry = realm.objects(WordEntry.self).filter("is_answered == false and is_defaulted == false").first
        self.currentWordEntryCorrect = nil
        self.currentWordEntryDefaulted = nil
        self.totalPoints = realm.objects(WordEntry.self).sum(ofProperty: "point")
        
        if self.currentWordEntry == nil {
            self.isGameOver = true
        }
    }
    
    mutating func answerQuestion(answeredAs: Bool) {
        self.currentWordEntryCorrect = self.currentWordEntry?.markDone(answeredAs: answeredAs)
    }
    
    mutating func defaultingAnswer() {
        self.currentWordEntryDefaulted = self.currentWordEntry?.markDoneDefaulting()
    }
}

class WordEntryViewModel: ViewModel<WordEntryViewState> {
    internal enum Command:Int {
        case FetchWordEntries = 1
        case FetchQuestion = 2
        case AnswerQuestion = 3
        case AnswerAsDefault = 4
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
            case .AnswerQuestion:
                self.viewState?.answerQuestion(answeredAs: data as! Bool)
                
                break
            case .AnswerAsDefault:
                self.viewState?.defaultingAnswer()
                
                break
            }
        }
    }
    
    func injectWordEntryStore(wordEntryStore:WordEntryStore) -> WordEntryViewModel {
        self.wordEntryStore = wordEntryStore
        return self
    }
}
