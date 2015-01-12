//
//  UHDSettingsDetailViewController.swift
//  uni-hd
//
//  Created by Felix on 11.01.15.
//  Copyright (c) 2015 Universität Heidelberg. All rights reserved.
//

import UIKit

class UHDSettingsDetailViewController: UITableViewController{
    
    var managedObjectContext: NSManagedObjectContext? {
        didSet {
            self._fetchedResultsControllerDatasource = nil
        }
    }
    
    var fetchedResultsControllerDatasource: VIFetchedResultsControllerDataSource? {
        if self._fetchedResultsControllerDatasource == nil {
            if let managedObjectContext = self.managedObjectContext {
                let fetchRequest = NSFetchRequest(entityName: "UHDMensa")
                fetchRequest.predicate = NSPredicate(format: "isFavourite == YES")
                fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "title", ascending: true) ]
                let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
                
                self._fetchedResultsControllerDatasource = VIFetchedResultsControllerDataSource(fetchedResultsController:fetchedResultsController, tableView:self.tableView, cellIdentifier:"Cell", configureCellBlock: { cell, item in
                    switch item {
                    case let mensa as UHDMensa:
                        cell.textLabel?.text = mensa.title
                    default:
                        break
                    }
                })
            }
        }
        return self._fetchedResultsControllerDatasource!
    }
    var _fetchedResultsControllerDatasource:VIFetchedResultsControllerDataSource? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.fetchedResultsControllerDatasource
        self.tableView.delegate = self;
    }

}
