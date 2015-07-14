//
//  ViewController.swift
//  ernieshw4
//
//  Created by Ernie Thompson on 7/14/15.
//  Copyright (c) 2015 Ernie Thompson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var erniesCastle:KangarooCastle = KangarooCastle(kName: "Ernies Bounce House")
    var joansCastle:BakeryCastle = BakeryCastle(bName: "Joan's Doughnut Shop")
    
    var views = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

