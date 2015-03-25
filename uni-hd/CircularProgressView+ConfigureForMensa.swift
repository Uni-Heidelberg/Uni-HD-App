//
//  CircularProgressView+ConfigureForMensa.swift
//  uni-hd
//
//  Created by Nils Fischer on 23.10.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import Foundation

extension CircularProgressView {
    
    public func configureForHoursOfMensa(mensa: UHDMensa)
    {
        self.image = mensa.image
        self.progress = mensa.hours.progress
        self.progressTintColor = mensa.hours.color
    }
    
}
