//
//  Node.swift
//  uni-hd
//
//  Created by Nils Fischer on 29.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import Foundation
import CoreData
import MapKit

public class Node: NSManagedObject {

    public override class func entityName() -> String! {
        return "Node"
    }
    
    @NSManaged private var latitude: Double
    @NSManaged private var longitude: Double

    public var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            self.latitude = newValue.latitude
            self.longitude = newValue.longitude
        }
    }
    
    // TODO: remove when unnecessary
    public class func insertNewObjectWithCoordinate(coordinate: CLLocationCoordinate2D, intoManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Node {
        let node = self.insertNewObjectIntoContext(managedObjectContext)
        node.coordinate = coordinate
        return node
    }
    
}
