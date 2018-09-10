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
    @IBOutlet weak var option: UILabel!
    @IBOutlet weak var response: UILabel!
    @IBOutlet weak var answerCorrect: UIButton!
    @IBOutlet weak var answerWrong: UIButton!
    
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
                    self.option.text = newViewState.currentWordEntry?.possibleAnswer()
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
                    self.enableButtons()
                }
            })
            .disposed(by: bag)
        
        self.viewModel.execute(command: WordEntryViewModel.Command.FetchQuestion)
        
        answerCorrect
            .rx
            .tap
            .subscribe(onNext: { [weak self] (_ : Void) in
                self?.disableButtons()
                self?.viewModel.execute(
                    command: WordEntryViewModel.Command.AnswerQuestion,
                    data: true as AnyObject)
            })
            .disposed(by: bag)
        
        answerWrong
            .rx
            .tap
            .subscribe(onNext: { [weak self] (_ : Void) in
                self?.disableButtons()
                self?.viewModel.execute(
                    command: WordEntryViewModel.Command.AnswerQuestion,
                    data: false as AnyObject)
            })
            .disposed(by: bag)
        
    }
    
    func disableButtons() {
        answerCorrect.isEnabled = false
        answerWrong.isEnabled = false
    }
    
    func enableButtons() {
        answerCorrect.isEnabled = true
        answerWrong.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
