//
//  Location.swift
//  uni-hd
//
//  Created by Nils Fischer on 28.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit
import MapKit
import SpriteKit

func MKMapRectForCoordinateRegion(region: MKCoordinateRegion) -> MKMapRect
{
    let a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(region.center.latitude + region.span.latitudeDelta / 2, region.center.longitude - region.span.longitudeDelta / 2))
    let b = MKMapPointForCoordinate(CLLocationCoordinate2DMake(region.center.latitude - region.span.latitudeDelta / 2, region.center.longitude + region.span.longitudeDelta / 2))
    return MKMapRectMake(min(a.x, b.x), min(a.y, b.y), abs(a.x - b.x), abs(a.y - b.y));
}


public class Location: UHDRemoteManagedObject {

    public override class func entityName() -> String! {
        return "Location"
    }

    @NSManaged private var managedTitle: String?
    @NSManaged public var institutions: NSSet
    @NSManaged public var managedCurrentDistance: NSNumber? // TODO: make private when not accessed by objc anymore
    @NSManaged private var imageData: NSData? // TODO: make transient when no sample data need to be provided anymore
    @NSManaged public var imageURL: NSURL?
    @NSManaged public var nodes: NSOrderedSet
    
    public var outline: MKPolygon? {
        if nodes.count > 0 {
            var outlineCoordinates = (nodes.array as! [Node]).map { $0.coordinate }
            return MKPolygon(coordinates: &outlineCoordinates, count: outlineCoordinates.count)
        } else {
            return nil
        }
    }

    public var coordinate: CLLocationCoordinate2D {
        return outline?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    /// A string composed by hierarchical positional components like building- and room numbers. To be overriden in subclasses.
    public var campusIdentifier: String? {
        return nil // TODO: implement?
    }
    
    public var institution: Institution? {
        get {
            if institutions.count == 1 {
                return institutions.anyObject() as? Institution
            } else {
                return nil
            }
        }
    }

    public var currentDistance: CLLocationDistance? {
        get {
            return managedCurrentDistance?.doubleValue >= 0 ? managedCurrentDistance?.doubleValue : nil
        }
        set {
            if let newValue = newValue {
                NSNumber(double: newValue)
            } else {
                managedCurrentDistance = nil
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
                return nil
            }
        }
        set {
            self.imageData = UIImageJPEGRepresentation(newValue, 1) // TODO: remove when sample data is unnecessary
        }
    }
    
    public var mapItem: MKMapItem? {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = self.title
        return mapItem
    }
    
}

extension Location: MKAnnotation {
    
    public var title: String? {
        get {
            return self.managedTitle ?? self.campusIdentifier
        }
        set {
            self.managedTitle = newValue
        }
    }

    public var subtitle: String? {
        if self.managedTitle != nil {
            return self.campusIdentifier
        } else {
            return nil
        }
        /*return ", ".join((self.institutions.allObjects as [Institution]).map({ institution -> String in
            return institution.title ?? "" // TODO: improve
        }))*/
    }
}
