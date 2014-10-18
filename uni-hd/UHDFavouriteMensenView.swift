//
//  UHDFavouriteMensenView.swift
//  uni-hd
//
//  Created by Felix on 18.10.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit


class UHDFavouriteMensenView: UIView {
    var favouriteMensenArray = [UHDMensa]()
    func addMensaToMensenArray (favouriteMensa:UHDMensa){
        favouriteMensenArray.append(favouriteMensa)
}
    func removeMensaFromMensenArray (favouriteMensa:UHDMensa){
        for (i, value) in enumerate(favouriteMensenArray) {
            if favouriteMensa == value {
                favouriteMensenArray.removeAtIndex(i)
            }
        }
}
}