//
//  Room.swift
//  uni-hd
//
//  Created by Nils Fischer on 31.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import Foundation
import CoreData
import MapKit

public class Room: Location {

    public override class func entityName() -> String! {
        return "Room"
    }
    
    @NSManaged public var identifier: String?
    @NSManaged public var building: Building?

    override public var campusIdentifier: String? {
        if let buildingIdentifier = self.building?.campusIdentifier {
            if let identifier = self.identifier {
                return buildingIdentifier + ", " + identifier
            }
        }
        return nil
    }
    
    override public var coordinate: CLLocationCoordinate2D {
        if self.outline == nil && building != nil {
            return building!.coordinate
        } else {
            return super.coordinate
        }
    }
    
    override public var institution: Institution? {
        if let institution = super.institution {
            return institution
        } else {
            return building?.institution
        }
    }
    
}
