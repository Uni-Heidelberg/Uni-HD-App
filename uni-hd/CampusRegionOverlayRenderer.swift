//
//  CampusRegionOverlay.swift
//  uni-hd
//
//  Created by Nils Fischer on 28.11.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import UIKit
import MapKit

class CampusRegionOverlayRenderer: MKTileOverlayRenderer {
    
    init(campusRegion: UHDCampusRegion) {

        let tileOverlay = CachedTileOverlay(URLTemplate: "http://appserver.physik.uni-heidelberg.de/static/map-tiles/\(campusRegion.identifier.lowercaseString)/{z}/{x}/{y}.png", cacheIdentifier: campusRegion.identifier) // TODO: use UHDRemoteStaticContentBaseURL
        tileOverlay.geometryFlipped = true
        tileOverlay.minimumZ = 15
        tileOverlay.maximumZ = 20
        
        super.init(overlay: tileOverlay)
    }
    
}
