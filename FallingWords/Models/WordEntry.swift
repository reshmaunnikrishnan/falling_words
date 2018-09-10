//
//  WordEntry.swift
//  FallingWords
//
//  Created by Reshma Unnikrishnan on 10.09.18.
//  Copyright © 2018 babbel. All rights reserved.
//

import Foundation
import RealmSwift

class WordEntry: Object {
    @objc dynamic var text_eng:String = ""
    @objc dynamic var text_spa:String = ""
    
    @objc dynamic var wrong_text_spa:String = ""
    
    @objc dynamic var is_answered:Bool = false
    @objc dynamic var point:Int = 0
    
    // Primary Key required for saving
    override class func primaryKey() -> String? {
        return "text_eng"
    }
    
    func save() -> WordEntry {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(self, update: true)
        }
        
        return self
    }
    
    func populateWrongAnswer() {
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "text_spa != %@", self.text_spa)
        
        let randomEntries = realm
            .objects(WordEntry.self)
            .filter(predicate)
            .sample(1)
        try! realm.write {
            self.wrong_text_spa = (randomEntries.first?.text_spa)!
        }
    }
}
