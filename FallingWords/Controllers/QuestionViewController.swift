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
    @IBOutlet weak var score: UILabel!
    
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
                
                self.score.text = String(newViewState.totalPoints)
                
                if newViewState.currentWordEntry != nil && oldViewState?.currentWordEntry != newViewState.currentWordEntry {
                    self.question.text = newViewState.currentWordEntry?.text_eng
                    self.option.text = newViewState.currentWordEntry?.possibleAnswer()
                    
                    self.option.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height * -1)
                    
                    UIView.animate(withDuration: 4, delay: 1, options: .curveLinear, animations: {
                        self.option.transform = .identity
                    }, completion: { finished in
                        self.option.transform = CGAffineTransform(translationX: 0, y: 0)
                        
                        if self.viewModel.viewState?.currentWordEntryCorrect == nil {
                            self.disableButtons()
                            
                            self.response.text = "Time is up. No points for you!"
                            self.response.textColor = UIColor.gray
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.viewModel.execute(command: WordEntryViewModel.Command.AnswerAsDefault)
                            }
                        }
                    })
                }
                
                if newViewState.currentEntryAnswered() {
                    self.option.layer.removeAllAnimations()
                    
                    if newViewState.currentWordEntryCorrect == true {
                        self.response.text = "Good Job! That is the right answer!"
                        self.response.textColor = UIColor.green
                    }
                    
                    if newViewState.currentWordEntryCorrect == false {
                        self.response.text = "Oops! That is the wrong answer!"
                        self.response.textColor = UIColor.red
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.viewModel.execute(command: WordEntryViewModel.Command.FetchQuestion)
                    }
                } else {
                    self.response.text = ""
                    self.enableButtons()
                }
            })
            .disposed(by: bag)
        
        self.viewModel.execute(command: WordEntryViewModel.Command.FetchQuestion)
        
        attachButtonEvents()
    }
    
    private func attachButtonEvents() {
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
