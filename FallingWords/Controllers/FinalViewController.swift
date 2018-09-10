//
//  FinalViewController.swift
//  FallingWords
//
//  Created by Reshma Unnikrishnan on 10.09.18.
//  Copyright © 2018 babbel. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController {

    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var resultStatement: UILabel!
    
    var viewModel:WordEntryViewModel!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let totalPoints = (viewModel.viewState?.totalPoints)!
        let totalItems = (viewModel.viewState?.totalItems)!
        let percent = Int(Double(totalPoints)/Double(totalItems) * 10)

        points.text = String(describing: totalPoints) + " out of " + String(describing: totalItems)
        
        switch percent {
        case (0...1):
            resultStatement.text = "😰"
            break
        case (2...3):
            resultStatement.text = "🤧"
            break
        case (4...5):
            resultStatement.text = "🙄"
            break
        case (6...7):
            resultStatement.text = "😌"
            break
        case (8...9):
            resultStatement.text = "😏"
            break
        default:
            resultStatement.text = "😎"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
