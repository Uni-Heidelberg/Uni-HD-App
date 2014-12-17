//
//  UHDBuildingDetailViewController.swift
//  uni-hd
//
//  Created by Nils Fischer on 16.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import UIKit
import MessageUI

class UHDBuildingDetailViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    var building: UHDBuilding? {
        didSet {
            if let prevBuilding = oldValue {
                NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextObjectsDidChangeNotification, object: prevBuilding.managedObjectContext)
            }
            if let building = building {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "managedObjectContextObjectsDidChange:", name: NSManagedObjectContextObjectsDidChangeNotification, object: building.managedObjectContext)
            }
            self.configureView()
        }
    }
    
    
    // MARK: Interface Elements
    
    @IBOutlet private var headerView: UIView!
    @IBOutlet private weak var headerImageView: UIImageView!
    
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.adjustFrameForParallaxedHeaderView(self.headerImageView)
    }
    
    func configureView()
    {
        self.headerImageView.image = self.building?.image
        if self.headerImageView.image == nil {
            self.tableView.tableHeaderView = nil
        } else {
            self.tableView.tableHeaderView = self.headerView
        }
        
        self.title = self.building?.title
        
        self.tableView.reloadData()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: User Interaction
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let building = self.building {
            
            switch self.sections[indexPath.section] {
                
            case .Location:
            
                // selected address
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Auf der Karte anzeigen", comment: ""), style: .Default, handler: { action in

                    self.showOnMap()
                    
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                }))
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Route hierhin", comment: ""), style: .Default, handler: { action in
                    
                    self.getDirections()
                    
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                }))
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Abbrechen", comment: ""), style: .Cancel, handler: { action in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            case .Contact:
            let actions = self.contactProperties[indexPath.row].actions
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            for action in actions {
                alertController.addAction(action)
            }
            self.presentViewController(alertController, animated: true, completion: {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
                
            case .Events(let events):
                if let talk = events[indexPath.row] as? UHDTalkItem {
                    if let detailVC = UIStoryboard(name: "news", bundle: nil).instantiateViewControllerWithIdentifier("talkDetail") as? UHDTalkDetailViewController {
                        detailVC.talkItem = talk
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
                
        default:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        }
    }
    
    @IBAction func showOnMapButtonPressed(sender: AnyObject) {
        self.showOnMap()
    }
    
    func showOnMap() {
        if let building = self.building {
            self.tabBarController?.selectedIndex = 2; // TODO: make dynamic
            if let mapsNavC = self.tabBarController?.selectedViewController? as? UINavigationController {
                if let mapsVC = mapsNavC.viewControllers.first as? UHDMapsViewController {
                    mapsNavC.popToViewController(mapsVC, animated: mapsNavC==self.navigationController)
                    mapsVC.showLocation(building, animated: true)
                }
            }
        }
    }
    
    @IBAction func getDirectionsButtonPressed(sender: AnyObject) {
        self.getDirections()
    }
    
    func getDirections() {
        if let building = self.building {
            MKMapItem.openMapsWithItems([ MKMapItem.mapItemForCurrentLocation(), building.mapItem ], launchOptions: [ MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking ])
        }
    }
    
    
    // MARK: Sections and Properties
    
    enum DetailSection {
        case Title, Location, Contact([DetailProperty]), Events([UHDEventItem]), FloorPlan
        
        var localizedTitle: String? {
            switch self {
            case .Title: return nil
            case .Location: return nil
            case .Contact: return NSLocalizedString("Kontakt", comment: "")
            case .FloorPlan: return NSLocalizedString("Raumplan", comment: "")
            case .Events: return NSLocalizedString("Kommende Veranstaltungen", comment: "")
            }
        }
    }
    
    var sections: [DetailSection] {
        if let building = self.building {
            var sections: [DetailSection] = [ .Title, .Location ]
            let contactProperties = self.contactProperties
            if contactProperties.count > 0 {
                sections.append(.Contact(contactProperties))
            }
            if let upcomingEvents = building.upcomingEvents as? [UHDEventItem] {
                if upcomingEvents.count > 0 {
                    sections.append(.Events(upcomingEvents))
                }
            }
            if building.campusIdentifier == "INF 227" {
                sections.append(.FloorPlan)
            }
            return sections
        }
        return []
    }
    
    struct DetailProperty {
        let title: String
        let content: String
        let actions: [UIAlertAction]
    }
    
    var contactProperties: [DetailProperty] {
        var properties = [DetailProperty]()
        if let building = self.building {
            if let telephone = building.telephone {
                properties.append(DetailProperty(title: NSLocalizedString("Telefon", comment: ""), content: telephone, actions: [ UIAlertAction(title: NSLocalizedString("Anrufen", comment: ""), style: .Default, handler: { action in
                    if let telURL = NSURL(string: "tel:\(telephone)") {
                        let success = UIApplication.sharedApplication().openURL(telURL)
                    }
                }), UIAlertAction(title: NSLocalizedString("Abbrechen", comment: ""), style: .Cancel, handler: nil) ]))
            }
            if let email = building.email {
                properties.append(DetailProperty(title: NSLocalizedString("Email", comment: ""), content: email, actions: [ UIAlertAction(title: NSLocalizedString("Email schreiben", comment: ""), style: .Default, handler: { action in
                    if MFMailComposeViewController.canSendMail() {
                        let mailComposeVC = MFMailComposeViewController()
                        mailComposeVC.mailComposeDelegate = self
                        mailComposeVC.setToRecipients([ email ])
                        self.presentViewController(mailComposeVC, animated: true, completion: nil)
                    }
                }), UIAlertAction(title: NSLocalizedString("Abbrechen", comment: ""), style: .Cancel, handler: nil) ]))
            }
            if let url = building.url {
                if let urlString = url.absoluteString {
                    properties.append(DetailProperty(title: NSLocalizedString("Web", comment: ""), content: urlString, actions: [ UIAlertAction(title: NSLocalizedString("In Safari öffnen", comment: ""), style: .Default, handler: { action in
                        let success = UIApplication.sharedApplication().openURL(url)
                    }), UIAlertAction(title: NSLocalizedString("Abbrechen", comment: ""), style: .Cancel, handler: nil) ]))
                }
            }
        }
        return properties
    }
    
    
    // MARK: Table View Datasource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.sections[section] {
        case .Title, .FloorPlan:
            return 1
        case .Contact(let contactProperties):
            return contactProperties.count
        case .Location:
            return 2
        case .Events(let events):
            return min(events.count, 3)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let building = self.building!
        
        switch self.sections[indexPath.section] {
            
        case .Title:
            let cell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as UHDBuildingDetailTitleCell
            cell.titleLabel.text = self.building?.title
            var subtitleComponents = [String]()
            if let campusIdentifier = building.campusIdentifier {
                subtitleComponents.append(campusIdentifier)
            }
            if let categoryTitle = building.category?.title {
                subtitleComponents.append(categoryTitle)
            }
            cell.subtitleLabel.text = " | ".join(subtitleComponents)
            return cell
    
        case .Contact(let contactProperties):
            let cell = tableView.dequeueReusableCellWithIdentifier("propertyCell", forIndexPath: indexPath) as UHDBuildingDetailPropertyCell
            let property = contactProperties[indexPath.row]
            cell.titleLabel.setTitle(property.title, forState: .Normal)
            cell.contentLabel.text = property.content
            return cell
            
        case .Events(let events):
            let cell = tableView.dequeueReusableCellWithIdentifier("talkCell", forIndexPath: indexPath) as UHDTalkItemCell
            let event = events[indexPath.row]
            if let talk = event as? UHDTalkItem {
                cell.configureForItem(talk)
            } else {
                cell.configureForItem(nil)
            }
            return cell
            
        case .Location:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("propertyCell", forIndexPath: indexPath) as UHDBuildingDetailPropertyCell
                cell.titleLabel.setTitle("Adresse", forState: .Normal)
                cell.contentLabel.text = building.address?.formattedDescription?
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as UHDBuildingDetailLocationCell
                cell.mapView.removeAnnotations(cell.mapView.annotations)
                cell.mapView.addAnnotation(building)
                cell.mapView.showAnnotations([ building ], animated: false)
                return cell
            }
        
        case .FloorPlan:
            let cell = tableView.dequeueReusableCellWithIdentifier("floorPlanCell", forIndexPath: indexPath) as UITableViewCell
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].localizedTitle
    }
    
    
    // MARK: Managed Object Context Notifications
    
    func managedObjectContextObjectsDidChange(notification: NSNotification)
    {
        if let building = self.building {
            if let userInfo = notification.userInfo {
                if let updatedObjects = userInfo[NSUpdatedObjectsKey] as? NSSet {
                    if updatedObjects.containsObject(building) {
                        self.configureView()
                    }
                }
            }
        }
    }
    
    // MARK: Scroll View Delegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView==self.tableView) {
            self.tableView.adjustFrameForParallaxedHeaderView(self.headerImageView)
        }
    }
    
    
    // MARK: Mail Compose View Controller Delegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
