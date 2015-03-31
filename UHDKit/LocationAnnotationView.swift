//
//  LocationAnnotationView.swift
//  uni-hd
//
//  Created by Nils Fischer on 31.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit
import MapKit

public class LocationAnnotationView: MKAnnotationView {
    
    public func configureForLocation(location: Location) {
        self.annotation = location
        
        self.canShowCallout = true
        
        if let image = location.image {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 22
            self.leftCalloutAccessoryView = imageView
        } else {
            self.leftCalloutAccessoryView = nil
        }
        
        /*// image
        if (!self.shouldHideImage && building) {
            
            CGRect rect = CGRectMake(0, 0, 44, 44);
            
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGContextAddEllipseInRect(context, rect);
            CGContextClip(context);
            
            [[self.annotation.image applyBlurWithRadius:10 tintColor:[UIColor colorWithWhite:0 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil] drawInRect:rect];
            
            [[UIColor whiteColor] setStroke];
            CGFloat frameWidth = 7;
            CGContextSetLineWidth(context, frameWidth);
            CGContextStrokeEllipseInRect(context, rect);
            
            if (building.campusIdentifier) {
                CGRect captionRect = CGRectInset(rect, frameWidth + 1, frameWidth + 1);
                NSMutableParagraphStyle *captionParagraphStyle = [[NSMutableParagraphStyle alloc] init];
                captionParagraphStyle.alignment = NSTextAlignmentCenter;
                NSAttributedString *caption = [[NSAttributedString alloc] initWithString:building.campusIdentifier attributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:9], NSParagraphStyleAttributeName: captionParagraphStyle }];
                CGRect captionTextRect = [caption boundingRectWithSize:captionRect.size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                [caption drawInRect:CGRectMake(captionRect.origin.x + captionRect.size.width / 2 - captionTextRect.size.width / 2, captionRect.origin.y + captionRect.size.height / 2 - captionTextRect.size.height / 2, captionTextRect.size.width, captionTextRect.size.height)];
            }
            
            self.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
        } else {
            self.image = nil;
        }
        */
    }
    
}
