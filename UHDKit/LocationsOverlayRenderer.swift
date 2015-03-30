//
//  LocationsOverlayRenderer.swift
//  uni-hd
//
//  Created by Nils Fischer on 29.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit

class LocationsOverlayRenderer: MKOverlayRenderer {
    
    let locationsOverlay: LocationsOverlay
    
    convenience init(locationsOverlay: LocationsOverlay) {
        self.init(overlay: locationsOverlay)
    }
    
    override init!(overlay: MKOverlay) {
        if let locationsOverlay = overlay as? LocationsOverlay {
            self.locationsOverlay = locationsOverlay
        } else {
            self.locationsOverlay = LocationsOverlay() // TODO: return nil here
        }
        super.init(overlay: locationsOverlay)
    }
   
    override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext!) {
        super.drawMapRect(mapRect, zoomScale: zoomScale, inContext: context)
        
        CGContextSaveGState(context)
        UIGraphicsPushContext(context)
        UIColor.brandColor().setStroke()
        CGContextSetLineWidth(context, 30.0)
        CGContextSetAlpha(context, 0.5)
        CGContextSetLineJoin(context, kCGLineJoinRound)

        for location in locationsOverlay.locations {
            var polygon: MKPolygon?
            location.managedObjectContext?.performBlockAndWait {
                polygon = location.outline
            }
            if let polygon = polygon {
                /*let polygonRenderer = MKPolygonRenderer(polygon: polygon) // TODO: why does this not work?!
                polygonRenderer.fillColor = UIColor.greenColor()
                polygonRenderer.strokeColor = UIColor.redColor()
                polygonRenderer.lineWidth = 5.0
                polygonRenderer.drawMapRect(mapRect, zoomScale: zoomScale, inContext: context)*/
                if polygon.pointCount > 1 {
                    var coordinates = [CLLocationCoordinate2D](count: polygon.pointCount, repeatedValue: kCLLocationCoordinate2DInvalid)
                    polygon.getCoordinates(&coordinates, range: NSMakeRange(0, polygon.pointCount))
                    let points = coordinates.map { self.pointForMapPoint(MKMapPointForCoordinate($0)) }
                    CGContextMoveToPoint(context, points[0].x, points[0].y)
                    for point in points[1..<points.count] {
                        CGContextAddLineToPoint(context, point.x, point.y)
                    }
                    CGContextClosePath(context)
                }
            }
        }

        CGContextStrokePath(context)
        UIGraphicsPopContext()
        CGContextRestoreGState(context)
    }
    
}
