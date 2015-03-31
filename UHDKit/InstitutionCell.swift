//
//  InstitutionCell.swift
//  uni-hd
//
//  Created by Nils Fischer on 30.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit

internal class InstitutionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var institutionImageView: UIImageView!

    internal func configureForInstitution(institution: Institution) {
        self.titleLabel.text = institution.title;
        self.subtitleLabel.text = institution.location?.campusIdentifier
        self.institutionImageView.image = institution.image;
    }

    internal func configureForLocation(location: Location) {
        self.titleLabel.text = location.title
        self.subtitleLabel.text = location.subtitle
        self.institutionImageView.image = location.image;
    }

}
