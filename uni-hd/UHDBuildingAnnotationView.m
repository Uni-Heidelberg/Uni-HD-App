//
//  UHDBuildingAnnotationView.m
//  uni-hd
//
//  Created by Nils Fischer on 07.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDBuildingAnnotationView.h"
#import "UIImage+ImageEffects.h"

@implementation UHDBuildingAnnotationView

- (id)initWithAnnotation:(UHDBuilding *)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        self.rightCalloutAccessoryView = detailButton;

    }
    return self;
}

- (void)setAnnotation:(UHDBuilding *)annotation {
    [super setAnnotation:annotation];
    [self configureView];
}

- (void)configureView
{
    UHDBuilding *building = self.annotation;
    
    // image
    if (building) {
        
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
    
    
    // callout
    
    if (building.image) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)]; // TODO: dynamic size?
        imageView.image = building.image;
        self.leftCalloutAccessoryView = imageView;
    } else {
        self.leftCalloutAccessoryView = nil;
    }
}

@end
