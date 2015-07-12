//
//  ViewController.swift
//  erniehw2
//
//  Created by Ernie Thompson on 7/10/15.
//  Copyright (c) 2015 Ernie Thompson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let stringArray:[String] = ["Well hey, this is a String. What could possibly be next?", "Gag me with a spoon! It's another String!", "And a third...", "This is getting old...", "This is the last string in the array. But I dare you to hit Next ;)"]
    
    var ind:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLabel.text = stringArray[ind]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextTapped(sender: AnyObject) {
        
        ind = ++ind % stringArray.count
        
        myLabel.text = stringArray[ind]
    
    }
    
    @IBAction func lastTapped(sender: AnyObject) {
    
        ind = stringArray.count - 1
    
        myLabel.text = stringArray[ind]
    
    }
    
    @IBAction func firstTapped(sender: AnyObject) {
        
        ind = 0
        
        myLabel.text = stringArray[ind]
        
    }
    @IBAction func previousTapped(sender: AnyObject) {
        
        
        ind = (stringArray.count + (--ind % stringArray.count)) % stringArray.count
       
        myLabel.text = stringArray[ind]
    
    }
    
    @IBOutlet weak var myLabel: UILabel!

}

