//
//  InstitutionDetailViewController.swift
//  uni-hd
//
//  Created by Nils Fischer on 16.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import UIKit
import MessageUI
import MapKit

public class InstitutionDetailViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    public var institution: Institution? {
        didSet {
            if let prevInstitution = oldValue {
                NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextObjectsDidChangeNotification, object: prevInstitution.managedObjectContext)
            }
            if let institution = institution {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "managedObjectContextObjectsDidChange:", name: NSManagedObjectContextObjectsDidChangeNotification, object: institution.managedObjectContext)
            }
            self.configureView()
        }
    }
    
    // MARK: Interface Elements
    
    @IBOutlet private var headerView: UIView!
    @IBOutlet private weak var headerImageView: UIImageView!
    
    
    // MARK: Lifecycle
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView.estimatedRowHeight = 160
        self.tableView.rowHeight = UITableViewAutomaticDimension
		
		self.tableView.registerNib(UINib(nibName: "NewsItemCell", bundle: NSBundle(forClass: UHDNewsItemCell.self)), forCellReuseIdentifier: "newsCell")
		self.tableView.registerNib(UINib(nibName: "EventItemCell", bundle: NSBundle(forClass: UHDEventItemCell.self)), forCellReuseIdentifier: "eventCell")
		self.tableView.registerNib(UINib(nibName: "TalkItemCell", bundle: NSBundle(forClass: UHDTalkItemCell.self)), forCellReuseIdentifier: "talkCell")
        self.tableView.registerNib(UINib(nibName: "SourceCell", bundle: NSBundle(forClass: UHDNewsSourceCell.self)), forCellReuseIdentifier: "sourceCell")
        self.tableView.registerNib(UINib(nibName: "LocationDetailCell", bundle: NSBundle(forClass: LocationDetailCell.self)), forCellReuseIdentifier: "locationCell")
    }
	
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.adjustFrameForParallaxedHeaderView(self.headerImageView)
    }
    
    func configureView()
    {
        self.headerImageView.image = self.institution?.image
        if self.headerImageView.image == nil {
            self.tableView.tableHeaderView = nil
        } else {
            self.tableView.tableHeaderView = self.headerView
        }
        
        self.title = self.institution?.title
        
        self.tableView.reloadData()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: User Interaction
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let institution = self.institution {
            
            switch self.sections[indexPath.section] {
                
            case .Title:
                if indexPath.row == 1 {
                    self.showMensaMenuButtonPressed(self)
                }
                
            case .Locations(let locations):
                let location = locations[indexPath.row]
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Auf der Karte anzeigen", comment: ""), style: .Default, handler: { action in
                    self.showOnMap(location)
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                }))
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Route hierhin", comment: ""), style: .Default, handler: { action in
                    self.getDirections(location)
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                }))
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Abbrechen", comment: ""), style: .Cancel, handler: { action in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            case .Contact(let contactProperties):
                let contactProperty = contactProperties[indexPath.row]
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
                switch contactProperty.content {
                case .Email(let email):
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Email schreiben", comment: ""), style: .Default, handler: { action in
                        if MFMailComposeViewController.canSendMail() {
                            let mailComposeVC = MFMailComposeViewController()
                            mailComposeVC.mailComposeDelegate = self
                            mailComposeVC.setToRecipients([ email ])
                            self.presentViewController(mailComposeVC, animated: true, completion: nil)
                        }
                    }))
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Abbrechen", comment: ""), style: .Cancel, handler: nil))
                case .Phone(let phone):
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Anrufen", comment: ""), style: .Default, handler: { action in
                        if let telURL = NSURL(string: "tel:\(phone)") {
                            let success = UIApplication.sharedApplication().openURL(telURL)
                        }
                    }))
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Abbrechen", comment: ""), style: .Cancel, handler: nil))
                case .Website(let url):
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("In Safari öffnen", comment: ""), style: .Default, handler: { action in
                            let success = UIApplication.sharedApplication().openURL(url)
                        }))
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Abbrechen", comment: ""), style: .Cancel, handler: nil))
                case .Post(let address):
                    // TODO: display something here?
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Abbrechen", comment: ""), style: .Cancel, handler: nil))
                }
                self.presentViewController(alertController, animated: true, completion: {
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                })
                
            case .Events(let events):
                if let talk = events[indexPath.row] as? UHDTalkItem {
                    if let detailVC = UIStoryboard(name: "news", bundle: NSBundle(forClass: UHDTalkDetailViewController.self)).instantiateViewControllerWithIdentifier("talkDetail") as? UHDTalkDetailViewController {
                        detailVC.talkItem = talk
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            
            case .News(let items):
                if let detailVC = UIStoryboard(name: "news", bundle: NSBundle(forClass: UHDNewsDetailViewController.self)).instantiateViewControllerWithIdentifier("newsDetail") as? UHDNewsDetailViewController {
                    detailVC.newsItem = items[indexPath.row]
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
                
        default:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        }
    }
    
    @IBAction func showOnMapButtonPressed(sender: AnyObject) {
        if let location = self.institution?.location {
            self.showOnMap(location)
        }
    }
    
    func showOnMap(location: Location) {
        self.showLocation(location, animated: true)
    }
    
    @IBAction func getDirectionsButtonPressed(sender: AnyObject) {
        if let location = self.institution?.location {
            self.getDirections(location)
        }
    }
    
    func getDirections(location: Location) {
        if let mapItem = location.mapItem {
            MKMapItem.openMapsWithItems([ MKMapItem.mapItemForCurrentLocation(), mapItem ], launchOptions: [ MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking ])
        }
    }
    
    @IBAction func showMensaMenuButtonPressed(sender: AnyObject) {
        if let mensa = self.institution as? Mensa {
            self.showMensaMenu(mensa, animated: true)
        }
    }
    
    // MARK: Sections and Properties
    
    private enum Section {
        case Title, Locations([Location]), Contact([Institution.ContactProperty]), Events([UHDEventItem]), News([UHDNewsItem])
        
        var localizedTitle: String? {
            switch self {
            case .Title: return nil
            case .Locations: return nil
            case .Contact: return NSLocalizedString("Kontakt", comment: "")
            case .Events: return NSLocalizedString("Kommende Veranstaltungen", comment: "")
            case .News: return NSLocalizedString("Aktuelle News", comment: "")
            }
        }
    }
    
    private var sections: [Section] {
        if let institution = self.institution {
            var sections: [Section] = [ .Title, .Locations(institution.locations.allObjects as! [Location]) ]
            let contactProperties = institution.contactProperties
            if contactProperties.count > 0 {
                sections.append(.Contact(contactProperties))
            }
            let upcomingEvents = institution.upcomingEvents(limit: 3)
            if upcomingEvents.count > 0 {
                sections.append(.Events(upcomingEvents))
            }
            let latestArticles = institution.latestArticles(limit: 3)
            if latestArticles.count > 0 {
                sections.append(.News(latestArticles))
            }
            return sections
        }
        return []
    }

    
    // MARK: Table View Datasource
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.sections[section] {
        case .Title:
            if let mensa = self.institution as? Mensa {
                return 2
            }
            return 1
        case .Contact(let contactProperties):
            return contactProperties.count
        case .Locations(let locations):
            return locations.count
        case .Events(let events):
            return events.count
        case .News(let items):
            return items.count
        }
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let institution = self.institution!
        
        switch self.sections[indexPath.section] {
            
        case .Title:
            switch indexPath.row {
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("mensaInfoCell", forIndexPath: indexPath) as! UITableViewCell
                if let mensa = institution as? Mensa {
                    if let statusLabel = cell.viewWithTag(1) as? UILabel { // TODO: implement properly
                        statusLabel.attributedText = mensa.attributedStatusDescription
                    }
                }
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as! InstitutionDetailTitleCell
                cell.titleLabel.text = institution.title
                cell.subtitleLabel.text = institution.parent?.affiliationDescription
                cell.statusLabel.attributedText = institution.attributedStatusDescription
                return cell
            }
    
        case .Contact(let contactProperties):
            let cell = tableView.dequeueReusableCellWithIdentifier("propertyCell", forIndexPath: indexPath) as! InstitutionDetailPropertyCell
            cell.configureForContactProperty(contactProperties[indexPath.row])
            return cell
            
        case .Events(let events):
            let event = events[indexPath.row]
            if let talk = event as? UHDTalkItem {
                let cell = tableView.dequeueReusableCellWithIdentifier("talkCell", forIndexPath: indexPath) as! UHDTalkItemCell
                cell.configureForTalk(talk)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! UHDEventItemCell
                cell.configureForEvent(event)
                return cell
            }
            
        case .News(let items):
            let cell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath) as! UHDNewsItemCell
            cell.configureForItem(items[indexPath.row])
            return cell
            
        case .Locations(let locations):
            let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! LocationDetailCell
            cell.configureForLocation(locations[indexPath.row])
            return cell
        }
    }
    
    override public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].localizedTitle
    }
    
    
    // MARK: Managed Object Context Notifications
    
    func managedObjectContextObjectsDidChange(notification: NSNotification)
    {
        if let institution = self.institution {
            if let userInfo = notification.userInfo {
                if let updatedObjects = userInfo[NSUpdatedObjectsKey] as? NSSet {
                    if updatedObjects.containsObject(institution) {
                        self.configureView()
                    }
                }
            }
        }
    }
    
    // MARK: Scroll View Delegate
    
    override public func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView==self.tableView) {
            self.tableView.adjustFrameForParallaxedHeaderView(self.headerImageView)
        }
    }
    
    
    // MARK: Mail Compose View Controller Delegate
    
    public func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
