//
//  CircularProgressView+ConfigureForMensa.swift
//  uni-hd
//
//  Created by Nils Fischer on 23.10.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import Foundation

extension CircularProgressView {
    
    public func configureForHoursOfInstitution(institution: Institution)
    {
        self.image = institution.image
        if let hours = institution.hours {
            self.progress = hours.progress
            self.progressTintColor = hours.color
        }
    }
    
}
