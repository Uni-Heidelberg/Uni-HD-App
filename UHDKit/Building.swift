//
//  Building.swift
//  uni-hd
//
//  Created by Nils Fischer on 28.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import Foundation
import CoreData

public class Building: Location {

    public override class func entityName() -> String! {
        return "Building"
    }

    @NSManaged public var number: String?
    @NSManaged public var campusRegionId: NSNumber?
    @NSManaged public var campusRegion: CampusRegion?

    override public var campusIdentifier: String? {
        if let campusRegionIdentifier = self.campusRegion?.campusIdentifier {
            if let number = self.number {
                return campusRegionIdentifier + " " + number
            }
        }
        return nil
    }

}
