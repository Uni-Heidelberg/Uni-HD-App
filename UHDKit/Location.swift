//
//  Location.swift
//  uni-hd
//
//  Created by Nils Fischer on 28.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit
import MapKit


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

    @NSManaged private var managedTitle: String? // FIXME: this seems to be a bug in Xcode
    public var title: String? {
        get {
            return self.managedTitle
        }
        set {
            self.managedTitle = newValue
        }
    }
    @NSManaged public var institutions: NSSet
    @NSManaged public var managedCurrentDistance: NSNumber? // TODO: make private when not accessed by objc anymore
    @NSManaged public var imageData: NSData?
    @NSManaged public var imageURL: NSURL?

    public var location: CLLocation = CLLocation(latitude: 0, longitude: 0) // TODO: store properly in database
    public var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }
    public var boundingMapRect: MKMapRect {
        return MKMapRectForCoordinateRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))
    }
    
    /// A string composed by hierarchical positional components like building- and room numbers. To be overriden in subclasses.
    public var campusIdentifier: String? {
        return nil // TODO: implement?
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
            self.imageData = UIImageJPEGRepresentation(image, 1) // TODO: remove when sample data is unnecessary
        }
    }
    
    public var mapItem: MKMapItem? {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = self.title
        return mapItem
    }
    
}

extension Location: MKAnnotation {
    
    public var subtitle: String {
        return ", ".join((self.institutions.allObjects as [Institution]).map({ institution -> String in
            return institution.title ?? "" // TODO: improve
        }))
    }
}
