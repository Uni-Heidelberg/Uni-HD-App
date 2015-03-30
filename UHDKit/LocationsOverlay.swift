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
    
    public func locationForCoordinate(coordinate: CLLocationCoordinate2D) -> Location? {
        let mapPoint = MKMapPointForCoordinate(coordinate)
        for location in locations {
            if let polygon = location.outline {
                // TODO: improve
                let path = CGPathCreateMutable()
                var coordinates = [CLLocationCoordinate2D](count: polygon.pointCount, repeatedValue: kCLLocationCoordinate2DInvalid)
                polygon.getCoordinates(&coordinates, range: NSMakeRange(0, polygon.pointCount))
                let points = coordinates.map { MKMapPointForCoordinate($0) }
                CGPathMoveToPoint(path, nil, CGFloat(points[0].x), CGFloat(points[0].y))
                for point in points[1..<points.count] {
                    CGPathAddLineToPoint(path, nil, CGFloat(point.x), CGFloat(point.y))
                }
                let mapPointAsCGP = CGPoint(x: mapPoint.x, y: mapPoint.y)
                if CGPathContainsPoint(path, nil, mapPointAsCGP, false) {
                    return location
                }
            }
        }
        return nil
    }
    
}
