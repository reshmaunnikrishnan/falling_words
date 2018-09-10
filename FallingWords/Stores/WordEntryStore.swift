//
//  WordEntryStore.swift
//  FallingWords
//
//  Created by Reshma Unnikrishnan on 10.09.18.
//  Copyright © 2018 babbel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol WordEntryStore {
    func fetchWordEntries() -> Driver<[WordEntry]>
}
