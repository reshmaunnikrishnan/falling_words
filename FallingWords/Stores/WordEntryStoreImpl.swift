//
//  WordEntryStoreImpl.swift
//  FallingWords
//
//  Created by Reshma Unnikrishnan on 10.09.18.
//  Copyright © 2018 babbel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

class WordEntryStoreImpl: WordEntryStore {
    internal func fetchWordEntries() -> Driver<[WordEntry]> {
        let url = "https://gist.githubusercontent.com/DroidCoder/7ac6cdb4bf5e032f4c737aaafe659b33/raw/baa9fe0d586082d85db71f346e2b039c580c5804/words.json";
        
        return requestJSON(.get, url)
            .catchError { error in
                return Observable.never()
            }
            .map({ (response, json) -> [WordEntry] in
                guard let items = json as? [AnyObject] else {return []}
                return items.map {WordEntry(value: $0).save()}
            })
            .map({ (wordEntries) -> [WordEntry] in
                wordEntries.forEach({ (wordEntry) in
                    wordEntry.populateWrongAnswer()
                })
                
                return wordEntries
            })
            .asDriver(onErrorJustReturn: [])
    }
}
