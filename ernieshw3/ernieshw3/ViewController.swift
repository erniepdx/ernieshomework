//
//  ViewController.swift
//  ernieshw3
//
//  Created by Ernie Thompson on 7/13/15.
//  Copyright (c) 2015 Ernie Thompson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    var roster:[(String, String)] = [("Ernie Thompson", "Student"),("Brad Pizzimenti", "Student"),("Tyler Franks", "Student"),("Al She", "Instructor"),("Brad Johnson", "Instructor"),("Jordana Gustafson", "Manager")]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roster.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:
        
        NSIndexPath) -> UITableViewCell {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
            
            let (name, role) = roster[indexPath.row]
            
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = role
            
            return cell
            
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

