//
//  UHDFavouriteMensenView.swift
//  uni-hd
//
//  Created by Felix on 18.10.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit
@objc
protocol UHDFavouriteMensenViewDelegate {
    
    func dismissTableHeaderView()
    
}
@objc

class UHDFavouriteMensenView: UIView {
    @IBOutlet var imageViews: Array<UIImageView>!
    var delegate: UHDFavouriteMensenViewDelegate?
    
    var favouriteMensenArray: [UHDMensa] = []{
        didSet {
            if oldValue.count>favouriteMensenArray.count{
                
            self.imageViews[oldValue.count-1].image=nil
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
    func refreshHeaderViewForMensa(newFavouriteMensa:UHDMensa){
        
        if(newFavouriteMensa.isFavourite){
        self.addMensaToMensenArray(newFavouriteMensa)
        //Mensa added to MensaArray
        }
        if(!newFavouriteMensa.isFavourite){
        self.removeMensaFromMensenArray(newFavouriteMensa)
        //Mensa removed from MensaArray
        }
        if favouriteMensenArray.count == 0
        {
            delegate?.dismissTableHeaderView()
        }
        for (i, value) in enumerate(favouriteMensenArray) {
            self.imageViews[i].image = value.image
        }
    }
}