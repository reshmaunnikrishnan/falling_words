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
}
