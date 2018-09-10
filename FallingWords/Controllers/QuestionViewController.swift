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
                
                if newViewState.currentWordEntryCorrect != nil {
                    if newViewState.currentWordEntryCorrect == true {
                        self.response.text = "Good Job! That is the right answer!"
                        self.response.textColor = UIColor.green
                    }
                    
                    if newViewState.currentWordEntryCorrect == false {
                        self.response.text = "Oops! That is the wrong answer!"
                        self.response.textColor = UIColor.red
                    }
                    
                    Observable<Int>
                        .timer(
                            RxTimeInterval(1),
                            scheduler: MainScheduler.instance)
                        .subscribe(onNext: { (_) in
                            self.viewModel.execute(command: WordEntryViewModel.Command.FetchQuestion)
                        })
                        .disposed(by: self.bag)
                    
                } else {
                    self.response.text = ""
                }
            })
            .disposed(by: bag)
        
        self.viewModel.execute(command: WordEntryViewModel.Command.FetchQuestion)
        
        option1
            .rx
            .tap
            .subscribe(onNext: { [weak self] (_ : Void) in
                self?.viewModel.execute(
                    command: WordEntryViewModel.Command.AnswerQuestion,
                    data: self?.option1.titleLabel?.text as AnyObject)
            })
            .disposed(by: bag)
        option2
            .rx
            .tap
            .subscribe(onNext: { [weak self] (_ : Void) in
                self?.viewModel.execute(
                    command: WordEntryViewModel.Command.AnswerQuestion,
                    data: self?.option2.titleLabel?.text as AnyObject)
            })
            .disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
