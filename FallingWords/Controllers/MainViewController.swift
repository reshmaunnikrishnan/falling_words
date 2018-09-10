//
//  ViewController.swift
//  FallingWords
//
//  Created by Reshma Unnikrishnan on 10.09.18.
//  Copyright © 2018 babbel. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var startGame: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To see the realm DB use
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

