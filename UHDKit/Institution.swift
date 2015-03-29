//
//  Institution.swift
//  uni-hd
//
//  Created by Nils Fischer on 27.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import Foundation
import CoreData
import UHDRemoteKit

public class Institution: UHDRemoteManagedObject {

    public override class func entityName() -> String! {
        return "Institution"
    }
    
    @NSManaged public var osmId: String?
    @NSManaged public var title: String?
    @NSManaged private var imageData: NSData? // TODO: reconsider having an image for an institution - it's a spatial property, so only associate to Location?
    @NSManaged public var imageURL: NSURL?
    @NSManaged public var parent: Institution?
    @NSManaged public var children: NSSet
    @NSManaged public var locations: NSSet
    @NSManaged public var newsSources: NSSet
    
    public var contactProperties: [ContactProperty] = [] // TODO: implement
    public var hours: Hours? { // TODO: implement
        return nil
    }

    public var mutableLocations: NSMutableSet {
        return self.mutableSetValueForKey("locations")
    }
    
    public var mutableNewsSources: NSMutableSet {
        return self.mutableSetValueForKey("newsSources")
    }
    
    public var location: Location? {
        get {
            if locations.count == 1 {
                return locations.anyObject() as? Location
            } else {
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self.locations = NSSet(object: newValue)
            } else {
                self.locations = NSSet()
            }
        }
    }
    
    public var image: UIImage? {
        get {
            if let imageData = self.imageData {
                return UIImage(data: imageData)
            } else if let imageURL = self.imageURL {
                let request = NSURLRequest(URL: imageURL, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 60)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue(), completionHandler: { response, data, connectionError in
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            self.imageData = data
                        }
                    }
                })
                return nil
            } else {
                return location?.image
            }
        }
        set {
            self.imageData = UIImageJPEGRepresentation(image, 1) // TODO: remove when sample data is unnecessary
        }
    }
    
    public var affiliationDescription: String? {
        if let title = self.title {
            if let parentDescription = self.parent?.affiliationDescription {
                return title + " < " + parentDescription
            } else {
                return title
            }
        } else {
            return nil
        }
    }
    
    public func upcomingEvents(#limit: Int) -> [UHDEventItem] {
        let fetchRequest = NSFetchRequest(entityName: UHDEventItem.entityName())
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "date", ascending: true) ]
        fetchRequest.predicate = NSPredicate(format: "source.institution == %@ && date > %@", self, NSDate())
        fetchRequest.fetchLimit = limit
        return self.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [UHDEventItem] ?? []
    }
    
    public func latestArticles(#limit: Int) -> [UHDNewsItem] {
        let fetchRequest = NSFetchRequest(entityName: UHDNewsItem.entityName())
        fetchRequest.includesSubentities = false
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "date", ascending: false) ]
        fetchRequest.predicate = NSPredicate(format: "source.institution == %@", self, NSDate())
        fetchRequest.fetchLimit = limit
        return self.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [UHDNewsItem] ?? []
    }
    
    public var attributedStatusDescription: NSAttributedString {
        let attributedStatusDescription = NSMutableAttributedString()
        if let hours = self.hours {
            attributedStatusDescription.appendAttributedString(hours.attributedDescription)
        }
        if let currentDistance = self.location?.currentDistance {
            let distanceFormatter = MKDistanceFormatter()
            attributedStatusDescription.appendAttributedString(NSAttributedString(string: ", \(distanceFormatter.stringFromDistance(currentDistance)) entfernt")) // TODO: localize
        }
        return attributedStatusDescription
    }

}

public struct ContactProperty {
    
    let description: String?
    let content: Content
    
    public enum Content: Printable {
        case Email(String), Phone(String), Website(NSURL), Post(Address)
        
        public var description: String {
            switch self {
            case .Email:
                return NSLocalizedString("Email", comment: "")
            case .Phone:
                return NSLocalizedString("Telefon", comment: "")
            case .Website:
                return NSLocalizedString("Webseite", comment: "")
            case .Post:
                return NSLocalizedString("Anschrift", comment: "")
            }
        }
        
        public struct Address: Printable {
            
            let street: String?
            let postalCode: String?
            let city: String?
            
            public var description: String {
                var description = ""
                if let street = self.street {
                    description += street + "\n"
                }
                if let postalCode = self.postalCode {
                    description += postalCode
                    if city != nil {
                        description += " "
                    }
                }
                if let city = self.city {
                    description += city
                }
                return description
            }
            
        }

    }
}

