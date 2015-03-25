//
//  UHDSettingsViewController.swift
//  uni-hd
//
//  Created by Nils Fischer on 08.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import UIKit

public class UHDSettingsViewController: UITableViewController {

    public var managedObjectContext: NSManagedObjectContext? {
        didSet {
            if let oldValue = oldValue {
                NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: oldValue)
            }
            self.configureView()
            if let managedObjectContext = managedObjectContext {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "managedObjectContextDidSave:", name: NSManagedObjectContextDidSaveNotification, object: managedObjectContext)
            }
        }
    }
    
    private var userDefaultsChangeTriggered = false
    
    
    // MARK: UI Elements
    
    @IBOutlet weak var sourcesCell: UITableViewCell!
    @IBOutlet weak var subscribedSourcesDetailLabel: UILabel!
    @IBOutlet weak var favouritedMensasDetailLabel: UILabel!
    @IBOutlet weak var favouritedMealsDetailLabel: UILabel!
    @IBOutlet weak var mensaPriceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var showCampusOverlaySwitch: UISwitch!
    @IBOutlet weak var emphasizeVegetarianSwitch: UISwitch!

    
    
    // MARK: Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    // TODO: remove this, should not be necessary .. but call from managedObjectContextDidSave does not yield the correct countForFetchRequest
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.configureView()
    }
    
    private func configureView() {
        if !self.isViewLoaded() {
            return
        }
        
        // Mensa Price Category
        if let mensaPriceCategory = (NSUserDefaults.standardUserDefaults().objectForKey("UHDUserDefaultsKeyMensaPriceCategory") as? NSNumber)?.integerValue {
            self.mensaPriceSegmentedControl.selectedSegmentIndex = mensaPriceCategory
        } else {
            self.mensaPriceSegmentedControl.selectedSegmentIndex = -1
        }
        
        // Subscribed Sources
        let fetchRequestSources = NSFetchRequest(entityName: UHDNewsSource.entityName())
        fetchRequestSources.predicate = NSPredicate(format: "subscribed == YES")
        if let subscribedSourcesCount = self.managedObjectContext?.countForFetchRequest(fetchRequestSources, error: nil) {
            self.subscribedSourcesDetailLabel.text = "\(subscribedSourcesCount) " + NSLocalizedString("abonniert", comment: "")
        } else {
            self.subscribedSourcesDetailLabel.text = nil
        }
        
        // Favourite Mensas
        let fetchRequestMensas = NSFetchRequest(entityName: UHDMensa.entityName())
        fetchRequestMensas.predicate = NSPredicate(format: "isFavourite == YES")
        if let favouritedMensasCount = self.managedObjectContext?.countForFetchRequest(fetchRequestMensas, error: nil) {
            self.favouritedMensasDetailLabel.text = "\(favouritedMensasCount) " + NSLocalizedString("favorisiert", comment: "")
        } else {
            self.favouritedMensasDetailLabel.text = nil
        }
        
        // Favourite Meals
        let fetchRequestMeals = NSFetchRequest(entityName: UHDMeal.entityName())
        fetchRequestMeals.predicate = NSPredicate(format: "isFavourite == YES")
        if let favouritedMealsCount = self.managedObjectContext?.countForFetchRequest(fetchRequestMeals, error: nil) {
            self.favouritedMealsDetailLabel.text = "\(favouritedMealsCount) " + NSLocalizedString("favorisiert", comment: "")
        } else {
            self.favouritedMealsDetailLabel.text = nil
        }
        
        // Vegetarian Switch
        if let emphasizeVegetarianMeals = (NSUserDefaults.standardUserDefaults().objectForKey("UHDUserDefaultsKeyVegetarian") as? NSNumber)?.boolValue {
            self.emphasizeVegetarianSwitch.on = emphasizeVegetarianMeals
        } else {
            self.emphasizeVegetarianSwitch.on = false
        }
        
        // Show Campus Overlay
        if let showCampusOverlay = (NSUserDefaults.standardUserDefaults().objectForKey("UHDUserDefaultsKeyShowCampusOverlay") as? NSNumber)?.boolValue {
            self.showCampusOverlaySwitch.on = showCampusOverlay
        } else {
            self.showCampusOverlaySwitch.on = true
        }
        
    }
    
    
    // MARK: User Interaction
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == tableView.indexPathForCell(sourcesCell) {
            if let sourcesNavC = UIStoryboard(name: "news", bundle: nil).instantiateViewControllerWithIdentifier("sourcesNav") as? UINavigationController {
                if let sourcesVC = sourcesNavC.viewControllers[0] as? UHDNewsSourcesViewController {
                    sourcesVC.managedObjectContext = self.managedObjectContext
                    self.presentViewController(sourcesNavC, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showSettingsDetailForMensa":
                if let vc = segue.destinationViewController as? UHDSettingsDetailViewController {
                    vc.managedObjectContext = self.managedObjectContext
                }
            default:
                break
            }
        }
    }
    
    @IBAction func mensaPriceSegmentedControlValueChanged(sender: UISegmentedControl) {
        self.userDefaultsChangeTriggered = true
        NSUserDefaults.standardUserDefaults().setInteger(sender.selectedSegmentIndex, forKey: "UHDUserDefaultsKeyMensaPriceCategory")
        self.userDefaultsChangeTriggered = false
    }
    @IBAction func vegetarianSwitchValueChanged(sender: UISwitch) {
        self.userDefaultsChangeTriggered = true
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "UHDUserDefaultsKeyVegetarian")
        self.userDefaultsChangeTriggered = false
    }
    
    @IBAction func showCampusOverlaySwitchValueChanged(sender: UISwitch) {
        self.userDefaultsChangeTriggered = true
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "UHDUserDefaultsKeyShowCampusOverlay")
        self.userDefaultsChangeTriggered = false
    }
    
    
    // MARK: Update Notifications
    
    func userDefaultsDidChange(notification: NSNotification) {
        if !self.userDefaultsChangeTriggered {
            self.configureView()
        }
    }
    
    func managedObjectContextDidSave(notification: NSNotification) {
        self.configureView()
    }
    
}
