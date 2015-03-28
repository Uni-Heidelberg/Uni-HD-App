//
//  UHDKit.swift
//  uni-hd
//
//  Created by Nils Fischer on 28.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import Foundation
import CoreData

public class CampusRegion: Location {

    public override class func entityName() -> String! {
        return "CampusRegion"
    }

    @NSManaged public var identifier: String?
    @NSManaged public var buildings: NSSet

    override public var campusIdentifier: String? {
        return identifier
    }
    
}
