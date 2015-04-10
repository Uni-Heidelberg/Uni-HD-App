//
//  CampusMapView.swift
//  uni-hd
//
//  Created by Nils Fischer on 29.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit
import MapKit

public class CampusMapView: UIView {
    
    public lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        return mapView
    }()
    
    public var datasource: CampusMapViewDatasource?
    public var delegate: CampusMapViewDelegate?
    
    private var osmTileOverlay: MKOverlay = {
        let osmTileOverlay = MKTileOverlay(URLTemplate: "http://tile.openstreetmap.org/{z}/{x}/{y}.png")
        osmTileOverlay.canReplaceMapContent = true
        return osmTileOverlay
    }()
    
    private lazy var locationsOverlay: LocationsOverlay = LocationsOverlay()
    
    public private(set) var selectedLocation: Location?
    
    public lazy var userTrackingButton: MKUserTrackingBarButtonItem = {
        let userTrackingButton = MKUserTrackingBarButtonItem(mapView: self.mapView)
        return userTrackingButton
    }()
    
    
    // MARK: Lifecycle

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(mapView)
        
        // Use OpenStreetMaps
        mapView.addOverlay(osmTileOverlay, level: .AboveLabels)
        
        // Add locations overlay
        mapView.addOverlay(locationsOverlay)

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
        
        // Reload locations overlay
        reloadLocationsOverlay()

    }
    
    
    // MARK: Public interface
    
    public func showLocation(location: Location, animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(location)
        mapView.selectAnnotation(location, animated: animated)
        mapView.showAnnotations([ location ], animated: animated)
        self.selectedLocation = location
    }
    
    public func clearSelectionAnimated(animated: Bool) {
        mapView.removeAnnotation(selectedLocation)
        self.selectedLocation = nil
    }
    
    public func reloadLocationsOverlay() {
        locationsOverlay.locations = self.datasource?.locationsForOverlayInCampusMapView(self) ?? []
        mapView.removeOverlay(locationsOverlay)
        mapView.addOverlay(locationsOverlay)
    }
    
    
    // MARK: User Interaction
    
    func handleTapOnMapView(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .Ended {

            clearSelectionAnimated(false)

            let coordinate = mapView.convertPoint(gestureRecognizer.locationInView(mapView), toCoordinateFromView: mapView)

            if let tappedLocation = locationsOverlay.locationForCoordinate(coordinate) {
                self.showLocation(tappedLocation, animated: true)
            }

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
        } else if overlay === self.locationsOverlay {
            return LocationsOverlayRenderer(overlay: overlay)
        }
        return nil
    }
    
    public func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView? {
        if let location = annotation as? Location {
            let locationAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("locationAnnotation") as? LocationAnnotationView ?? LocationAnnotationView(annotation: annotation, reuseIdentifier: "locationAnnotation")! // FIXME: remove forced unwrapping
            locationAnnotationView.configureForLocation(location)
            if self.userInteractionEnabled {
                locationAnnotationView.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
            } else {
                locationAnnotationView.rightCalloutAccessoryView = nil
            }
            return locationAnnotationView
        }
        return nil
    }
    
    public func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if let location = view.annotation as? Location {
            delegate?.campusMapView(self, didSelectLocation: location)
        }
    }
    
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
    
    func locationsForOverlayInCampusMapView(campusMapView: CampusMapView) -> [Location]
    
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

