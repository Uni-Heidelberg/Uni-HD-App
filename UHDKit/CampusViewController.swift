//
//  CampusViewController.swift
//  uni-hd
//
//  Created by Nils Fischer on 29.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit

public class CampusViewController: UIViewController {

    public var managedObjectContext: NSManagedObjectContext?
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    private var selectedLocation: Location?
    public func setSelectedLocation(location: Location?, animated: Bool) {
        self.selectedLocation = location
        self.configureView(animated: animated)
    }
    
    
    // MARK: Interface Elements
    
    @IBOutlet private var campusMapView: CampusMapView!

    
    // MARK: Search Controller
    
    private lazy var searchResultsViewController: UHDMapsSearchResultsViewController? = {
        let searchResultsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("searchResults") as? UHDMapsSearchResultsViewController
        searchResultsViewController?.delegate = self
        searchResultsViewController?.managedObjectContext = self.managedObjectContext
        return searchResultsViewController
    }()
    
    private lazy var searchController: UISearchController? = {
        let searchController = UISearchController(searchResultsController: self.searchResultsViewController)
        searchController.searchResultsUpdater = self.searchResultsViewController
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    
    // MARK: Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // trigger location authorization
        // TODO: inform user first
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // Configure Campus Map View
        campusMapView.datasource = self
        campusMapView.delegate = self
        
        // Add tracking button
        self.navigationItem.leftBarButtonItem = campusMapView.userTrackingButton
        
        // Add Search Bar & Controller
        self.navigationItem.titleView = searchController?.searchBar
        self.definesPresentationContext = true // TOOD: is this really necessary?
    
        self.configureView(animated: false)
    }
    
    private func configureView(animated: Bool = false) {
        if !self.isViewLoaded() {
            return
        }
        
        if let location = self.selectedLocation {
            campusMapView.showLocation(location, animated: animated)
        }

        campusMapView.reloadLocationsOverlay()
    }

    
    // MARK: User Interaction
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case "showInstitutionDetail":
                if let detailVC = segue.destinationViewController as? InstitutionDetailViewController {
                    detailVC.institution = sender as? Institution
                }
            default:
                break
            }
        }
    }
    
    public override func showLocation(location: Location, animated: Bool) {
        searchController?.active = false
        self.setSelectedLocation(location, animated: animated)
    }
}


// MARK: Campus Map View Datasource and Delegate

extension CampusViewController: CampusMapViewDatasource {
    
    public func locationsForOverlayInCampusMapView(campusMapView: CampusMapView) -> [Location] {
        let fetchRequest = NSFetchRequest(entityName: Location.entityName())
        return managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [Location] ?? []
    }
    
}

extension CampusViewController: CampusMapViewDelegate {
    public func campusMapView(campusMapView: CampusMapView, didSelectLocation location: Location) {
        self.performSegueWithIdentifier("showInstitutionDetail", sender: location.institution)
    }
}


// MARK: Campus Search View Controller Delegate

extension CampusViewController: UHDMapsSearchResultsViewControllerDelegate {
    
    public func searchResultsViewController(viewController: UHDMapsSearchResultsViewController!, didSelectInstitution institution: Institution!) {
        if let location = institution.location {
            self.showLocation(location, animated: true)
        }
    }
    
}


// MARK: Search Controller Delegate

extension CampusViewController: UISearchControllerDelegate {
    
}


// MARK: Location Manager Delegate

extension CampusViewController: CLLocationManagerDelegate {
    
}
