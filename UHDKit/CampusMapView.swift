//
//  CampusMapView.swift
//  uni-hd
//
//  Created by Nils Fischer on 29.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit

public class CampusMapView: UIView {
    
    public var mapView = MKMapView()
    
    public var datasource: CampusMapViewDatasource?
    public var delegate: CampusMapViewDelegate?
    
    private var osmTileOverlay: MKOverlay = {
        let osmTileOverlay = MKTileOverlay(URLTemplate: "http://tile.openstreetmap.org/{z}/{x}/{y}.png")
        osmTileOverlay.canReplaceMapContent = true
        return osmTileOverlay
    }()
    
    public private(set) var selectedLocation: Location?
    
    public lazy var userTrackingButton: MKUserTrackingBarButtonItem = {
        let userTrackingButton = MKUserTrackingBarButtonItem(mapView: self.mapView)
        return userTrackingButton
    }()
    
    
    // MARK: Lifecycle

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(mapView)
        mapView.delegate = self
        
        // Use OpenStreetMaps
        mapView.addOverlay(osmTileOverlay, level: .AboveLabels)

        // Show appropriate region
        // TODO: limit scrolling to max region
        mapView.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(49.4085, 8.68685), 3000, 3000);
        
        // Add Tap Gesture Recognizer
        let mapViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action:"handleTapOnMapView:")
        mapViewTapGestureRecognizer.delegate = self
        mapView.addGestureRecognizer(mapViewTapGestureRecognizer)
        // Make sure double-taps don't trigger the single tap gesture recognizer
        let mapViewDoubleTapGestureRecognizer = UITapGestureRecognizer()
        mapViewDoubleTapGestureRecognizer.numberOfTapsRequired = 2
        mapViewDoubleTapGestureRecognizer.delegate = self
        mapView.addGestureRecognizer(mapViewDoubleTapGestureRecognizer)
        mapViewTapGestureRecognizer.requireGestureRecognizerToFail(mapViewDoubleTapGestureRecognizer)

    }
    
    
    // MARK: Public interface
    
    public func showLocation(location: Location, animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(location)
        mapView.showAnnotations([ location ], animated: animated)
        mapView.selectAnnotation(location, animated: animated)
        self.selectedLocation = location
    }
    
    public func clearSelectionAnimated(animated: Bool) {
        mapView.removeAnnotation(selectedLocation)
        self.selectedLocation = nil
    }
    
    // MARK: User Interaction
    
    func handleTapOnMapView(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .Ended {

            clearSelectionAnimated(false)

            let coordinate = mapView.convertPoint(gestureRecognizer.locationInView(mapView), toCoordinateFromView: mapView)

            //if (MKMapRectContainsPoint([building boundingMapRect], MKMapPointForCoordinate(coordinate))) {
            // Tapped on building
            // Continue for already annotated buildings
            //if ([self.mapView.annotations containsObject:building]) continue;
            // Present (empty) annotation with callout
            //self.selectedLocation = building;
            //[self.mapView addAnnotation:building];
            //[self.mapView selectAnnotation:building animated:YES];
        }
    }
    
    // MARK: Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        mapView.frame = self.bounds
    }

}


// MARK: Map View Delegate

extension CampusMapView: MKMapViewDelegate {
    
    public func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay === self.osmTileOverlay {
            return MKTileOverlayRenderer(overlay: overlay)
        }
        /*
MKMapRect boundingMapRect = [overlay boundingMapRect];
MKMapPoint polygonPoints[4] = {
boundingMapRect.origin,
MKMapPointMake(boundingMapRect.origin.x + boundingMapRect.size.width, boundingMapRect.origin.y),
MKMapPointMake(boundingMapRect.origin.x + boundingMapRect.size.width, boundingMapRect.origin.y + boundingMapRect.size.height),
MKMapPointMake(boundingMapRect.origin.x, boundingMapRect.origin.y + boundingMapRect.size.height)
};
MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:[MKPolygon polygonWithPoints:polygonPoints count:4]];
renderer.fillColor = [UIColor blackColor];
return renderer;
*/
        return nil
    }

    public func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView? {
        if let building = annotation as? Building {
            let buildingAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("buildingAnnotation") as? UHDBuildingAnnotationView ?? UHDBuildingAnnotationView(annotation: building, reuseIdentifier: "buildingAnnotation")
            buildingAnnotationView?.canShowCallout = true
            buildingAnnotationView?.annotation = building
            buildingAnnotationView?.shouldHideImage = true
            return buildingAnnotationView
        }
        return nil
    }
    
    public func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if let location = view.annotation as? Location {
            delegate?.campusMapView(self, didSelectLocation: location)
        }
    }
    
    /*- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
    {
    // TODO: Only necessary because selection is strangely cleared right after tap occured
    if (self.selectedAnnotation && view.annotation == self.selectedAnnotation) {
    [mapView selectAnnotation:view.annotation animated:NO];
    }
    }*/
    
}


// MARK: Gesture Recognizer Delegate

extension CampusMapView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        // TODO: there should be a better way to make the callout button work...
        return !(touch.view is UIControl)
    }
    
}


// MARK: Datasource and Delegate

@objc public protocol CampusMapViewDatasource {
    
}

@objc public protocol CampusMapViewDelegate {
    
    func campusMapView(campusMapView: CampusMapView, didSelectLocation location: Location)

}

// Limit region
// TODO: This is not smooth enough for presentation yet

/*
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
self.lastValidMapRegion = mapView.region;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
if (!self.isAdjustingToValidMapRegion) {

MKCoordinateRegion restrictedRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(49.410029, 8.677434), 5000, 5000);
BOOL adjustRegion = NO;
if ((mapView.region.span.latitudeDelta > restrictedRegion.span.latitudeDelta * 2) || (mapView.region.span.longitudeDelta > restrictedRegion.span.longitudeDelta * 2) ) {
adjustRegion = YES;
}
if (!MKMapRectIntersectsRect(self.mapView.visibleMapRect, MKMapRectForCoordinateRegion(restrictedRegion))) {
adjustRegion = YES;
}
if (adjustRegion) {
self.isAdjustingToValidMapRegion = YES;
[mapView setRegion:self.lastValidMapRegion animated:YES];
self.isAdjustingToValidMapRegion = NO;
}
}

if ((mapView.region.span.latitudeDelta > 0.0596 ) || (mapView.region.span.longitudeDelta > 0.071736) ) {

CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(49.4085, 8.68685);

MKCoordinateSpan spanOfNZ = MKCoordinateSpanMake(0.0596, 0.071736);

MKCoordinateRegion NZRegion = MKCoordinateRegionMake(centerCoord, spanOfNZ);

[mapView setRegion: NZRegion animated: YES];

}

if (mapView.region.center.latitude > 49.44 ) {

CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(49.44, mapView.region.center.longitude);

MKCoordinateSpan spanOfNZ = mapView.region.span;

MKCoordinateRegion NZRegion = MKCoordinateRegionMake(centerCoord, spanOfNZ);

[mapView setRegion: NZRegion animated: YES];

}

if (mapView.region.center.latitude < 49.4085 ) {

CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(49.4085, mapView.region.center.longitude);

MKCoordinateSpan spanOfNZ = mapView.region.span;

MKCoordinateRegion NZRegion = MKCoordinateRegionMake(centerCoord, spanOfNZ);

[mapView setRegion: NZRegion animated: YES];

}

if (mapView.region.center.longitude > 8.735 ) {

CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(mapView.region.center.latitude, 8.735);

MKCoordinateSpan spanOfNZ = mapView.region.span;

MKCoordinateRegion NZRegion = MKCoordinateRegionMake(centerCoord, spanOfNZ);

[mapView setRegion: NZRegion animated: YES];
}

if (mapView.region.center.longitude < 8.6387 ) {

CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(mapView.region.center.latitude, 8.6387);

MKCoordinateSpan spanOfNZ = mapView.region.span;

MKCoordinateRegion NZRegion = MKCoordinateRegionMake(centerCoord, spanOfNZ);

[mapView setRegion: NZRegion animated: YES];
}

self.isAdjustingToValidMapRegion = NO;

}*/

