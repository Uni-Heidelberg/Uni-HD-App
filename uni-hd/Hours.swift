//
//  Hours.swift
//  uni-hd
//
//  Created by Nils Fischer on 23.10.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import UIKit

class Hours: NSObject {
    
    var isOpen: Bool {
        return true
    }
    
    var progress: CGFloat {
        return 0.7
    }
    
    var color: UIColor {
        return UIColor(red: 76/255, green: 171/255, blue: 4/255, alpha: 1)
    }
    
    var attributedDescription: NSAttributedString {
        var attributedDescription = NSMutableAttributedString(string: "Geöffnet", attributes: [ NSForegroundColorAttributeName : self.color ])
        attributedDescription.appendAttributedString(NSAttributedString(string: " bis 22.00h (vielleicht)"))
        return attributedDescription
    }
   
}
