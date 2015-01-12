//
//  UHDSettingsDetailViewController.swift
//  uni-hd
//
//  Created by Felix on 11.01.15.
//  Copyright (c) 2015 Universität Heidelberg. All rights reserved.
//

import UIKit

// MARK: UI Elements

// @IBOutlet weak var tableView: UITableView!

class UHDSettingsDetailViewController: UITableViewController{
    
    var managedObjectContext: NSManagedObjectContext?
    
    var fetchedResultsControllerDatasource: VIFetchedResultsControllerDataSource {
        if _fetchedResultsControllerDatasource != nil {
            return _fetchedResultsControllerDatasource!
        }
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("UHDMensa", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "isFavourite == YES")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        let cellBlock: (UITableViewCell!, AnyObject!) -> Void = {cell, item in
            cell.textLabel.text = (item as UHDMensa).title}
        
        let afetchedResultsControllerDataSource: VIFetchedResultsControllerDataSource = VIFetchedResultsControllerDataSource(fetchedResultsController:aFetchedResultsController, tableView:self.tableView, cellIdentifier:"Cell", configureCellBlock:cellBlock)
        _fetchedResultsControllerDatasource = afetchedResultsControllerDataSource
        
        return _fetchedResultsControllerDatasource!
    }
    var _fetchedResultsControllerDatasource:VIFetchedResultsControllerDataSource? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.fetchedResultsControllerDatasource
        self.tableView.delegate = self;
    }
    
    // MARK: Table View Methods
    //
    //    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return 3
    //    }
    //    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
    //        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    //
    //        // Configure the cell
    //        cell.textLabel.text = "Favourisierte Mensa"
    //        return cell
    //    }
    
}
