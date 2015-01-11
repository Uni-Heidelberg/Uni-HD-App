//
//  UHDSettingsDetailViewController.swift
//  uni-hd
//
//  Created by Felix on 11.01.15.
//  Copyright (c) 2015 Universität Heidelberg. All rights reserved.
//

import Foundation

// MARK: UI Elements

// @IBOutlet weak var tableView: UITableView!

class UHDSettingsDetailViewController: UITableViewController{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
                
        // Configure the cell
        cell.textLabel.text = "Favourisierte Mensa"        
        return cell
    }
    
}
