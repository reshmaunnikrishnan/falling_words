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
    
    var viewModel:WordEntryViewModel!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        points.text = String(describing: (viewModel.viewState?.totalPoints)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
