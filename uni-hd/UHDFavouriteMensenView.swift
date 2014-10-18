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
        println("favouriteMensenArray is of type [UHDMensa] with \(favouriteMensenArray.count) items.")
}
}