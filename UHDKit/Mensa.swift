//
//  Mensa.swift
//  uni-hd
//
//  Created by Nils Fischer on 28.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import Foundation
import CoreData
import MapKit

public class Mensa: Institution {
    
    public override class func entityName() -> String! {
        return "Mensa"
    }
    
    @NSManaged public var isFavourite: Bool
    @NSManaged public var sections: NSSet
    
    override public var hours: Hours? {
        return Hours()
    }
    
    public func hasMenuForDate(date: NSDate) -> Bool {
        for section in self.sections {
            if section.dailyMenuForDate(date) != nil {
                return true
            }
        }
        return false
    }
    
}
