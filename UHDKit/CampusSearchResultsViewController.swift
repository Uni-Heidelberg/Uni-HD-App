//
//  CampusSearchViewController.swift
//  uni-hd
//
//  Created by Nils Fischer on 30.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit
import CoreData

public class CampusSearchResultsViewController: UITableViewController {

    public var managedObjectContext: NSManagedObjectContext!
    public var delegate: CampusSearchResultsViewControllerDelegate?
    
    private lazy var institutionsFetchedResultsControllerDataSource: VIFetchedResultsControllerDataSource = {
        let fetchRequest = NSFetchRequest(entityName: Institution.entityName())
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "title", ascending: true) ]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        let dataSource = VIFetchedResultsControllerDataSource(fetchedResultsController: fetchedResultsController, tableView: self.tableView, cellIdentifier: "institutionCell", configureCellBlock: { cell, item in
            if let cell = cell as? UHDBuildingCell {
                cell.configureForInstitution(item as Institution)
            }
        })
        return dataSource
    }()

    
    // MARK: User Interaction
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case "showInstitutionDetailFromSearchResults":
                if let indexPath = self.tableView.indexPathForSelectedRow() {
                    (segue.destinationViewController as? InstitutionDetailViewController)?.institution = institutionsFetchedResultsControllerDataSource.fetchedResultsController.objectAtIndexPath(indexPath) as? Institution
                }
            default:
                break
            }
        }
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = self.institutionsFetchedResultsControllerDataSource.fetchedResultsController.objectAtIndexPath(indexPath) as Institution
        self.delegate?.searchResultsViewController(self, didSelectInstitution: selectedItem)
    }
    
    public override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let selectedItem = self.institutionsFetchedResultsControllerDataSource.fetchedResultsController.objectAtIndexPath(indexPath) as Institution
        if let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("institutionDetail") as? InstitutionDetailViewController {
            detailVC.institution = selectedItem
            //((self.parentViewController as? UISearchController)?.delegate as? UIViewController)?.navigationController?.pushViewController(detailVC, animated: true) // TODO: this is super dirty, use segue instead
        }
    }
}

extension CampusSearchResultsViewController: UISearchResultsUpdating {
    
    public func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let searchTerms = searchText.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        //NSString *predicateFormat = @"(title CONTAINS[cd] %@) OR (buildingNumber CONTAINS[cd] %@) OR (campusRegion.title CONTAINS[cd] %@) OR (campusRegion.identifier CONTAINS[cd] %@) OR (ANY keywords.content CONTAINS[cd] %@)";
        let predicateFormat = "title CONTAINS[cd] %@"
        let predicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: searchTerms.map({ NSPredicate(format: predicateFormat, $0)! }))
        
        self.institutionsFetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.predicate = predicate
        self.institutionsFetchedResultsControllerDataSource.fetchedResultsController.performFetch(nil)
        self.tableView.reloadData()
    }
    
}

public protocol CampusSearchResultsViewControllerDelegate {
    
    func searchResultsViewController(viewController: CampusSearchResultsViewController, didSelectInstitution institution: Institution)
    
}
