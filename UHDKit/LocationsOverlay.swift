//
//  LocationsOverlay.swift
//  uni-hd
//
//  Created by Nils Fischer on 29.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit
import MapKit

public class LocationsOverlay: NSObject, MKOverlay {
   
    public var locations: [Location] = []
    
    public var boundingMapRect: MKMapRect {
        return MKMapRectWorld // TODO: implement outer bounding rect
    }
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 0, longitude: 0) // TODO: implement centroid
    }
    
}
