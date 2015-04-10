//
//  AppDelegate.swift
//  uni-hd
//
//  Created by Nils Fischer on 28.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit
import VILogKit
import UHDPersistenceKit
import UHDRemoteKit
import UHDKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    // MARK: Launch
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        // Configure logging
        // Swift logger
        VILogKit.logLevel = .Debug
        // Objective-C logger
        VILogger.defaultLogger().logLevel = VILogLevelDebug
        // RESTKit logger
        // Configured by settings environment variables
        // Edit scheme (Cmd + <) and add configurations to Run > Arguments, e.g.:
        // RKLogLevel.* = Debug
        RKLogConfigureFromEnvironment()
        
        // enable automatic network indicator display
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        
        // Setup remote datasources
        addRemoteDatasourceForKey(UHDConstants.RemoteDatasourceKey.News, baseURL: UHDRemoteConstants.Server.APIBaseURL.URLByAppendingPathComponent("news"), delegate: UHDNewsRemoteDatasourceDelegate())
        addRemoteDatasourceForKey(UHDConstants.RemoteDatasourceKey.Mensa, baseURL: UHDRemoteConstants.Server.APIBaseURL.URLByAppendingPathComponent("mensa"), delegate: UHDMensaRemoteDatasourceDelegate())
        addRemoteDatasourceForKey(UHDConstants.RemoteDatasourceKey.Maps, baseURL: UHDRemoteConstants.Server.APIBaseURL.URLByAppendingPathComponent("maps"), delegate: UHDMapsRemoteDatasourceDelegate())
        
        // Generate sample data
        UHDRemoteDatasourceManager.defaultManager().remoteDatasourceForKey(UHDConstants.RemoteDatasourceKey.Maps).generateSampleDataIfNeeded()
        
        // Refresh
        let timeIntervalSinceRefresh = UHDRemoteDatasourceManager.defaultManager().timeIntervalSinceRefresh
        if timeIntervalSinceRefresh < 0 || UHDRemoteDatasourceManager.defaultManager().timeIntervalSinceRefresh > 86400 { // TODO: improve
            UHDRemoteDatasourceManager.defaultManager().refreshAllWithCompletion { success, error in
                self.processSampleData() // TODO: remove eventually
            }
        } else {
            self.logger.log("Time since last complete refresh: \(timeIntervalSinceRefresh)s, not refreshing again.", forLevel: .Info)
        }
        
        // Configure default styles
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UINavigationBar.appearance().barTintColor = UIColor.brandColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.whiteColor() ]
        
        // Setup initial view controllers
        
        let storyboardsBundle = NSBundle(forClass: UHDMensaViewController.self)
        let managedObjectContext = self.persistentStack.managedObjectContext
        
        let initialViewController = { (storyboardName: String, storyboardBundle: NSBundle, iconPrefix: String, localizedTitle: String ) -> UIViewController in
            let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardsBundle)
            let initialVC = storyboard.instantiateInitialViewController() as! UIViewController
            // TODO: move selectedImage settings to storyboard when issue is resolved: can't find selectedImage in framework bundle
            initialVC.tabBarItem.title = localizedTitle
            initialVC.tabBarItem.image = UIImage(named: iconPrefix + "Icon", inBundle:storyboardBundle, compatibleWithTraitCollection: nil)
            initialVC.tabBarItem.selectedImage = UIImage(named: iconPrefix + "IconSelected", inBundle: storyboardsBundle, compatibleWithTraitCollection: nil)
            return initialVC
        }
        
        let mensaNavC = initialViewController("mensa", storyboardsBundle, "mensa", NSLocalizedString("Mensa", comment: "tab bar title")) as! UINavigationController
        (mensaNavC.topViewController as! UHDMensaViewController).managedObjectContext = managedObjectContext
        let newsNavC = initialViewController("news", storyboardsBundle, "news", NSLocalizedString("News", comment: "tab bar title")) as! UINavigationController
        let newsVC = newsNavC.topViewController as! UHDNewsViewController
        newsVC.managedObjectContext = managedObjectContext
        newsVC.displayMode = UHDNewsEventsDisplayModeNews
        let eventsNavC = initialViewController("news", storyboardsBundle, "events", NSLocalizedString("Veranstaltungen", comment: "tab bar title")) as! UINavigationController
        let eventsVC = eventsNavC.topViewController as! UHDNewsViewController
        eventsVC.managedObjectContext = managedObjectContext
        eventsVC.displayMode = UHDNewsEventsDisplayModeEvents
        let campusNavC = initialViewController("campus", storyboardsBundle, "maps", NSLocalizedString("Campus", comment: "tab bar title")) as! UINavigationController
        (campusNavC.topViewController as! CampusViewController).managedObjectContext = managedObjectContext
        let settingsNavC = initialViewController("settings", storyboardsBundle, "settings", NSLocalizedString("Konfiguration", comment: "tab bar title")) as! UINavigationController
        (settingsNavC.topViewController as! UHDSettingsViewController).managedObjectContext = managedObjectContext
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [ mensaNavC, newsNavC, eventsNavC, campusNavC, settingsNavC ]
        
        // Create and populate window
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.tintColor = UIColor.brandColor()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
    private func processSampleData() {
        // Stitch together generated maps sample data and remote data from server
        // TODO: remove when remote data becomes available!
        
        let managedObjectContext = self.persistentStack.managedObjectContext
        
        // Retrieve locations
        let locationsFetchRequest = NSFetchRequest(entityName: Location.entityName())
        let locations = managedObjectContext.executeFetchRequest(locationsFetchRequest, error: nil)! as! [Location]
        // Retrieve institutions
        let institutionsFetchRequest = NSFetchRequest(entityName: Institution.entityName())
        let institutions = managedObjectContext.executeFetchRequest(institutionsFetchRequest, error: nil)! as! [Institution]
        // Retrieve news sources
        let sourcesFetchRequest = NSFetchRequest(entityName: UHDNewsSource.entityName())
        let sources = managedObjectContext.executeFetchRequest(sourcesFetchRequest, error: nil)! as! [UHDNewsSource]

        // Retrieve Studentenwerk institution
        let stwFetchRequest = NSFetchRequest(entityName: Institution.entityName())
        stwFetchRequest.predicate = NSPredicate(format: "title == %@", "Studentenwerk")
        let stw = managedObjectContext.executeFetchRequest(stwFetchRequest, error: nil)?.first as? Institution
            
        // Add data to institutions
        for institution in institutions {
            if institution is Mensa {
                if institution.parent == nil {
                    institution.parent = institutions.filter({ $0.title == "Studentenwerk" }).first
                }
                if institution.url == nil {
                    institution.url = NSURL(string: "http://www.studentenwerk.uni-heidelberg.de/mensen")
                }
            }
            if let title = institution.title {
                var associatedBuildingCampusIdentifier: String?
                var associatedNewsSourceTitle: String?
                switch title {
                case "Zentralmensa":
                    associatedBuildingCampusIdentifier = "INF 304"
                    if institution.address == nil {
                        institution.address = Institution.Address(street: "Im Neuenheimer Feld 304", postalCode: "69120", city: "Heidelberg")
                    }
                case "Triplex-Mensa":
                    associatedBuildingCampusIdentifier = "ALT 2100"
                    if institution.address == nil {
                        institution.address = Institution.Address(street: "Grabengasse 14", postalCode: "69117", city: "Heidelberg")
                    }
                case "zeughaus":
                    associatedBuildingCampusIdentifier = "ALT 2010"
                    if institution.address == nil {
                        institution.address = Institution.Address(street: "Marstallhof 3", postalCode: "69117", city: "Heidelberg")
                    }
                case "Kirchhoff-Institut für Physik":
                    associatedNewsSourceTitle = title
                default:
                    break
                }
                if let campusIdentifier = associatedBuildingCampusIdentifier {
                    if institution.location == nil {
                        institution.location = locations.filter({ $0.campusIdentifier == campusIdentifier }).first
                    }
                }
                if let newsSourceTitle = associatedNewsSourceTitle {
                    if institution.newsSources.count == 0 {
                        if let source = sources.filter({ $0.title != nil && $0.title == newsSourceTitle }).first {
                            institution.mutableNewsSources.addObject(source)
                        }
                    }
                }

            }
        }

        // Associate locations to events
        let eventsFetchRequest = NSFetchRequest(entityName: UHDEventItem.entityName())
        if let events = managedObjectContext.executeFetchRequest(eventsFetchRequest, error: nil) as? [UHDEventItem] {
            for event in events {
                if event.location == nil {
                    let matchingLocations = locations.filter({ location in
                        switch location {
                        case let building as Building:
                            return building.title != nil && building.title == event.buildingString
                        case let room as Room:
                            return room.title != nil && room.title == event.roomString
                        default:
                            return false
                        }
                    })
                    event.location = matchingLocations.filter({ $0 is Room }).first ?? matchingLocations.first
                }
            }
        }
        
        // Associate news sources to institutions
        for sourceTitle in [ "Kirchhoff Institut für Physik", "Physikalisches Kolloquium", "Particle Colloquium" ] {
            sources.filter({ $0.title != nil && $0.title == sourceTitle }).first?.institution = institutions.filter({ $0.title == "Kirchhoff-Institut für Physik" }).first
        }
            
        // Distinguish between news and events sources
        
        if let sources = managedObjectContext.executeFetchRequest(sourcesFetchRequest, error: nil) as? [UHDNewsSource] {
        
            for source in sources {
                
                let newsFetchRequest = NSFetchRequest(entityName: UHDNewsItem.entityName())
                newsFetchRequest.includesSubentities = false
                newsFetchRequest.predicate = NSPredicate(format: "source == %@", source)
                
                let newsCount = managedObjectContext.countForFetchRequest(newsFetchRequest, error: nil)
                source.isNewsSource = newsCount > 0;
                
                let eventsFetchRequest = NSFetchRequest(entityName: UHDEventItem.entityName())
                eventsFetchRequest.includesSubentities = true
                eventsFetchRequest.predicate = NSPredicate(format: "source == %@", source)
                
                let eventsCount = managedObjectContext.countForFetchRequest(eventsFetchRequest, error: nil)
                source.isEventSource = eventsCount > 0;
            }
        }
        
        managedObjectContext.saveToPersistentStore(nil)

    }
    
    
    // MARK: Significant Time Change
    
    func applicationSignificantTimeChange(application: UIApplication) {
        
        // Refresh remote data
        UHDRemoteDatasourceManager.defaultManager().refreshAllWithCompletion(nil)

        // invalidate all cached section identifiers
        let fetchRequest = NSFetchRequest(entityName: UHDNewsItem.entityName())
        fetchRequest.includesSubentities = true
        if let newsItems = self.persistentStack.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) {
            for item in newsItems {
                item.resetSectionIdentifierCache()
            }
        }
        
    }
    
    
    // MARK: Persistent Stack
    
    lazy var persistentStack: UHDPersistentStack = {
        // TODO: better error handling?
        let modelsBundle = NSBundle(forClass: Mensa.self)
        let mensaModel = NSManagedObjectModel(contentsOfURL: modelsBundle.URLForResource("mensa", withExtension: "momd")!)!
        let newsModel = NSManagedObjectModel(contentsOfURL: modelsBundle.URLForResource("news", withExtension: "momd")!)!
        let campusModel = NSManagedObjectModel(contentsOfURL: modelsBundle.URLForResource("campus", withExtension: "momd")!)!
        let managedObjectModel = self.modelByMergingModels([ mensaModel, newsModel, campusModel ], foreignEntityNameKey: "UHDForeignEntityNameKey")
        
        let persistentStoreURL = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last as! NSURL).URLByAppendingPathComponent("uni-hd.sqlite")
        
        return UHDPersistentStack(managedObjectModel: managedObjectModel, persistentStoreURL: persistentStoreURL)
    }()

    
    // MARK: Model Merging
    
    private func modelByMergingModels(models: [NSManagedObjectModel], foreignEntityNameKey: String) -> NSManagedObjectModel {
        let mergedModel = NSManagedObjectModel()
        
        // Merge entities of all models, ignoring placeholder entities marked by existence of the foreignEntityNameKey in their userInfo
        var mergedModelEntities = [NSEntityDescription]()
        var ignoredSubentities = [String : [NSEntityDescription]]()
        for model in models {
            for entity in model.entities as! [NSEntityDescription] {
                if let foreignEntityName = entity.userInfo?[foreignEntityNameKey] as? String {
                    // Ignore placeholder
                    // TODO: use this key to actually map differently-named entities
                    // remember subentities to re-establish later
                    var subentities = ignoredSubentities[entity.name!] ?? [NSEntityDescription]()
                    subentities += entity.subentities as! [NSEntityDescription]
                    ignoredSubentities[entity.name!] = subentities
                } else {
                    mergedModelEntities.append(entity.copy() as! NSEntityDescription)
                }
            }
        }
        mergedModel.entities = mergedModelEntities
        
        // Merge subentities
        let entitiesByName = mergedModel.entitiesByName as! [String : NSEntityDescription]
        for entity in mergedModel.entities as! [NSEntityDescription] {
            var mergedSubentities = [NSEntityDescription]()
            if let ignored = ignoredSubentities[entity.name!] {
                for ignoredSubentity in ignored {
                    mergedSubentities.append(entitiesByName[ignoredSubentity.name!]!)
                }
            }
            for subentity in entity.subentities as! [NSEntityDescription] {
                mergedSubentities.append(entitiesByName[subentity.name!]!)
            }
            entity.subentities = mergedSubentities
        }
        
        return mergedModel
    }
    
    // MARK: Remote Datasources
    
    lazy var remoteDatasourceDelegates = [UHDRemoteDatasourceDelegate]()

    private func addRemoteDatasourceForKey(key: String, baseURL: NSURL, delegate:UHDRemoteDatasourceDelegate) {
        let remoteDatasource = UHDRemoteDatasource(persistentStack: self.persistentStack, remoteBaseURL: baseURL)
        
        self.remoteDatasourceDelegates.append(delegate)
        remoteDatasource.delegate = delegate
    
        UHDRemoteDatasourceManager.defaultManager().addRemoteDatasource(remoteDatasource, forKey:key)
    }

}

extension AppDelegate {
    var logger: Logger {
        return Logger.loggerForKeyPath("AppDelegate")
    }
}
