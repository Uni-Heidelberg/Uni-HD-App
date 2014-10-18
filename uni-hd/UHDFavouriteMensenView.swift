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
    @IBOutlet private weak var imageView1: UIImageView!
    @IBOutlet private weak var imageView2: UIImageView!
    @IBOutlet private weak var imageView3: UIImageView!

    var favouriteMensenArray: [UHDMensa] = []{
didSet {
    for (i, value) in enumerate(favouriteMensenArray) {
        if i==0 {imageView1.image = value.image}
        if i==1 {imageView2.image = value.image}
        if i==2 {imageView3.image = value.image}
        }
    }
    }
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