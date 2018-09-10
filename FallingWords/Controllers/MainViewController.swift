//
//  ViewController.swift
//  FallingWords
//
//  Created by Reshma Unnikrishnan on 10.09.18.
//  Copyright © 2018 babbel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet weak var startGame: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let bag = DisposeBag()
    
    var questionVC: QuestionViewController!;
    var finalVC: FinalViewController!;
    
    var viewModel:WordEntryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To see the realm DB use
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        self.viewModel = WordEntryViewModel().injectWordEntryStore(wordEntryStore: WordEntryStoreImpl())
        
        self.questionVC = self.storyboard?.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        self.questionVC.viewModel = self.viewModel
        
        self.finalVC = self.storyboard?.instantiateViewController(withIdentifier: "FinalViewController") as! FinalViewController
        self.finalVC.viewModel = self.viewModel
        
        viewModel
            .viewStateStream
            .subscribe(onNext: { (newViewState, oldViewState) in
                let newViewState = newViewState as! WordEntryViewState
                let oldViewState = oldViewState as? WordEntryViewState
                
                self.activityIndicator.isHidden = !newViewState.isLoading
                self.activityIndicator.startAnimating()
                
                if oldViewState?.isDataLoaded == false && newViewState.isDataLoaded == true {
                    self.navigationController?.pushViewController(self.questionVC, animated: true)
                }
                
                if newViewState.isGameOver == true {
                    self.navigationController?.pushViewController(self.finalVC, animated: true)
                }
            })
            .disposed(by: bag)
        
        viewModel.setViewState(viewstate: WordEntryViewState())
        
        startGame
            .rx
            .tap
            .subscribe(onNext: { [weak self] (_ : Void) in
                self?.viewModel.execute(command: WordEntryViewModel.Command.FetchWordEntries)
            })
            .disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

