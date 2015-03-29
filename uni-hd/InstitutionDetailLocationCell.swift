//
//  UHDBuildingDetailLocationCell.swift
//  uni-hd
//
//  Created by Nils Fischer on 16.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import UIKit

class InstitutionDetailLocationCell: UITableViewCell {

    @IBOutlet var campusMapView: CampusMapView!
    
    func configureForLocation(location: Location) {
/*        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(location)
        mapView.showAnnotations([ location ], animated: false)*/
        campusMapView.showLocation(location, animated: false)
    }
}
