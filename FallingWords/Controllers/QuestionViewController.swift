//
//  QuestionViewController.swift
//  FallingWords
//
//  Created by Reshma Unnikrishnan on 10.09.18.
//  Copyright © 2018 babbel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class QuestionViewController: UIViewController {

    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    
    @IBOutlet weak var response: UILabel!
    
    var viewModel:WordEntryViewModel!;
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel
            .viewStateStream
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (newViewState, oldViewState) in
                let newViewState = newViewState as! WordEntryViewState
                let oldViewState = oldViewState as? WordEntryViewState
                
                if newViewState.currentWordEntry != nil && oldViewState?.currentWordEntry != newViewState.currentWordEntry {
                    self.question.text = newViewState.currentWordEntry?.text_eng
                    self.option1.setTitle(newViewState.currentWordEntry?.text_spa, for: .normal)
                    self.option2.setTitle(newViewState.currentWordEntry?.wrong_text_spa, for: .normal)
                }
            })
            .disposed(by: bag)
        
        self.viewModel.execute(command: WordEntryViewModel.Command.FetchQuestion)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
