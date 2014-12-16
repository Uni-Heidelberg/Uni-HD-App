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
        if let detailSection = DetailSection(rawValue: indexPath.section) {
            
            switch detailSection {
                
            case .Location:
                
                if indexPath.row == 0 {
                    // selected address
                    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Auf der Karte anzeigen", comment: ""), style: .Default, handler: { action in
                        // TODO: implement
                        tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    }))
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Route hierhin", comment: ""), style: .Default, handler: { action in
                        // TODO: implement
                        tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    }))
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Abbrechen", comment: ""), style: .Cancel, handler: { action in
                        tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            case .Contact:
                let actions = self.contactProperties()[indexPath.row].actions
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
                for action in actions {
                    alertController.addAction(action)
                }
                self.presentViewController(alertController, animated: true, completion: {
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                })
            
            default:
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
        }
    }
    
    
    // MARK: Sections and Properties
    
    enum DetailSection: Int {
        case Title = 0, Location, Contact, FloorPlan
        
        var localizedTitle: String? {
            switch self {
            case .Title: return nil
            case .Location: return nil
            case .Contact: return NSLocalizedString("Kontakt", comment: "")
            case .FloorPlan: return NSLocalizedString("Raumplan", comment: "")
            }
        }
    }
    
    struct DetailProperty {
        let title: String
        let content: String
        let actions: [UIAlertAction]
    }
    
    func contactProperties() -> [DetailProperty] {
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
        if self.building == nil {
            return 0
        } else {
            return 4
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let detailSection = DetailSection(rawValue: section) {
            switch detailSection {
            case .Title, .FloorPlan:
                return 1
            case .Contact:
                return self.contactProperties().count
            case .Location:
                return 2
            }
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let building = self.building!
        
        let detailSection = DetailSection(rawValue: indexPath.section)!
        switch detailSection {
            
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
    
        case .Contact:
            let cell = tableView.dequeueReusableCellWithIdentifier("propertyCell", forIndexPath: indexPath) as UHDBuildingDetailPropertyCell
            let property = self.contactProperties()[indexPath.row]
            cell.titleLabel.setTitle(property.title, forState: .Normal)
            cell.contentLabel.text = property.content
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
        return DetailSection(rawValue: section)?.localizedTitle
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
