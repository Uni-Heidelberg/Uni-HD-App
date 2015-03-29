//
//  Hours.swift
//  uni-hd
//
//  Created by Nils Fischer on 23.10.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import UIKit

public class Hours: NSObject {
    
    public var isOpen: Bool {
        return true
    }
    
    public var progress: CGFloat {
        return 0.7
    }
    
    public var color: UIColor {
        return UIColor(red: 76/255, green: 171/255, blue: 4/255, alpha: 1)
    }
    
    public var attributedDescription: NSAttributedString {
        var attributedDescription = NSMutableAttributedString()
        attributedDescription.appendAttributedString(NSMutableAttributedString(string: "Geöffnet", attributes: [ NSForegroundColorAttributeName : self.color ]))
        attributedDescription.appendAttributedString(NSAttributedString(string: " bis 22.00h"))
        return attributedDescription
    }
   
}
