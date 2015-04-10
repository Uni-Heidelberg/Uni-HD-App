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
        let dataSource = VIFetchedResultsControllerDataSource(fetchedResultsController: fetchedResultsController, tableView: nil, cellIdentifier: "institutionCell", configureCellBlock: { cell, item in
            if let cell = cell as? InstitutionCell {
                cell.configureForInstitution(item as! Institution)
            }
        })
        return dataSource
    }()
    
    private lazy var locationsFetchedResultsControllerDataSource: VIFetchedResultsControllerDataSource = {
        let fetchRequest = NSFetchRequest(entityName: Location.entityName())
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "managedTitle", ascending: true) ]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        let dataSource = VIFetchedResultsControllerDataSource(fetchedResultsController: fetchedResultsController, tableView: nil, cellIdentifier: "institutionCell", configureCellBlock: { cell, item in
            if let cell = cell as? InstitutionCell {
                cell.configureForLocation(item as! Location)
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
        let selectedItem = self.fetchedResultsControllerDataSourceForSection(indexPath.section)!.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0)) as! NSManagedObject
        switch selectedItem {
        case let institution as Institution:
            self.delegate?.searchResultsViewController(self, didSelectInstitution: institution)
        case let location as Location:
            self.delegate?.searchResultsViewController(self, didSelectLocation: location)
        default:
            break
        }
    }
    
    public override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let selectedItem = self.fetchedResultsControllerDataSourceForSection(indexPath.section)!.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0)) as! NSManagedObject
        switch selectedItem {
        case let institution as Institution:
            if let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("institutionDetail") as? InstitutionDetailViewController {
                detailVC.institution = institution
                //((self.parentViewController as? UISearchController)?.delegate as? UIViewController)?.navigationController?.pushViewController(detailVC, animated: true) // TODO: this is super dirty, use segue instead
            }
        default:
            break
        }
    }
}


// MARK: Table View Datasource

extension CampusSearchResultsViewController {
    
    private func fetchedResultsControllerDataSourceForSection(section: Int) -> VIFetchedResultsControllerDataSource? {
        switch section {
        case 0:
            return self.institutionsFetchedResultsControllerDataSource
        case 1:
            return self.locationsFetchedResultsControllerDataSource
        default:
            return nil
        }
    }
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsControllerDataSourceForSection(section)!.tableView(tableView, numberOfRowsInSection: 0)
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let fetchedResultsControllerDataSource = self.fetchedResultsControllerDataSourceForSection(indexPath.section)!
        let cell = tableView.dequeueReusableCellWithIdentifier(fetchedResultsControllerDataSource.cellIdentifier) as! UITableViewCell
        let item = fetchedResultsControllerDataSource.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0)) as! NSManagedObject
        fetchedResultsControllerDataSource.configureCellBlock(cell, item)
        return cell
    }
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let fetchedResultsControllerDataSource = self.fetchedResultsControllerDataSourceForSection(section) {
            if fetchedResultsControllerDataSource === self.institutionsFetchedResultsControllerDataSource {
                return NSLocalizedString("Institutionen", comment: "")
            } else if fetchedResultsControllerDataSource === self.locationsFetchedResultsControllerDataSource {
                return NSLocalizedString("Orte", comment: "")
            }
        }
        return nil
    }
    
}


// MARK: Search

extension CampusSearchResultsViewController: UISearchResultsUpdating {
    
    public func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if searchText == "*" {
            self.institutionsFetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.predicate = nil
            self.locationsFetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.predicate = nil
        } else {
            let searchTerms = searchText.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            //NSString *predicateFormat = @"(title CONTAINS[cd] %@) OR (buildingNumber CONTAINS[cd] %@) OR (campusRegion.title CONTAINS[cd] %@) OR (campusRegion.identifier CONTAINS[cd] %@) OR (ANY keywords.content CONTAINS[cd] %@)";
            
            let institutionsPredicateFormat = "title CONTAINS[cd] %@"
            let institutionsPredicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: searchTerms.map({ NSPredicate(format: institutionsPredicateFormat, $0) }))
            self.institutionsFetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.predicate = institutionsPredicate
            let locationsPredicateFormat = "managedTitle CONTAINS[cd] %@"
            let locationsPredicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: searchTerms.map({ NSPredicate(format: locationsPredicateFormat, $0) }))
            self.locationsFetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.predicate = locationsPredicate
        }
        self.institutionsFetchedResultsControllerDataSource.reloadData()
        self.locationsFetchedResultsControllerDataSource.reloadData()
        self.tableView.reloadData()
    }
    
}


// MARK: Delegate Protocol

public protocol CampusSearchResultsViewControllerDelegate {
    
    func searchResultsViewController(viewController: CampusSearchResultsViewController, didSelectInstitution institution: Institution)
    func searchResultsViewController(viewController: CampusSearchResultsViewController, didSelectLocation location: Location)
    
}
