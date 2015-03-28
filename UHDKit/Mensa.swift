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
    
    public func hasMenuForDate(date: NSDate) -> Bool {
        for section in self.sections {
            if section.dailyMenuForDate(date) != nil {
                return true
            }
        }
        return false
    }
    
}
