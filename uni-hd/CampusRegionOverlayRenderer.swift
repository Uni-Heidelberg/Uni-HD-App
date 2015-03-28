//
//  CampusRegionOverlay.swift
//  uni-hd
//
//  Created by Nils Fischer on 28.11.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import UIKit
import MapKit
import VILogKit

// Convert an MKZoomScale to a zoom level where level 0 contains 4 256px square tiles,
// which is the convention used by gdal2tiles.py.
func zoomLevelForZoomScale(scale: MKZoomScale) -> Int {
    let tileSize: Double = 256
    let numTilesAt1_0 = MKMapSizeWorld.width / tileSize
    let zoomLevelAt1_0 = log2(numTilesAt1_0);  // add 1 because the convention skips a virtual level with 1 tile.
    let zoomLevel = max(0, Int(zoomLevelAt1_0) + Int(floor(log2(scale) + 0.5)));
    return zoomLevel;
}

public class CampusRegionOverlayRenderer: MKTileOverlayRenderer {
    
    public let tileOverlay: MKTileOverlay
    private let minimumZoomLevel: Int = 18
    
    public init(campusRegion: CampusRegion) {
        let tileOverlay = CachedTileOverlay(URLTemplate: UHDRemoteConstants.Server.StaticContentBaseURL.absoluteString! + "map-tiles/\(campusRegion.identifier)/{z}/{x}/{y}.png", cacheIdentifier: campusRegion.identifier ?? "Default")
        tileOverlay.geometryFlipped = true
        tileOverlay.minimumZ = 15
        tileOverlay.maximumZ = 20
        self.tileOverlay = tileOverlay
        
        super.init(overlay: tileOverlay)
    }
    
    override public func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext!) {
        let zoomLevel = zoomLevelForZoomScale(zoomScale)
        if zoomLevel < minimumZoomLevel {
            CGContextSetAlpha(context, 0.2) // TODO: implement smooth fading
        }
        super.drawMapRect(mapRect, zoomScale: zoomScale, inContext: context);
    }
    
}
