//
//  UHDBuildingAnnotationView.m
//  uni-hd
//
//  Created by Nils Fischer on 07.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDBuildingAnnotationView.h"

@implementation UHDBuildingAnnotationView

- (id)initWithAnnotation:(UHDBuilding *)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        self.rightCalloutAccessoryView = detailButton;
        
        /*UIGraphicsBeginImageContext(CGSizeMake(50, 50));
        [annotation.image drawInRect:CGRectMake(0, 0, 50, 50)];
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UILabel *captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        captionLabel.text = annotation.identifier;
        [self addSubview:captionLabel];*/
        
        self.frame = CGRectMake(0, 0, 44, 44);
        
    }
    return self;
}

- (void)setAnnotation:(UHDBuilding *)annotation {
    [super setAnnotation:annotation];
    
    // Configure callout
    UHDBuilding *building = self.annotation;
    if (building.image) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)]; // TODO: dynamic size?
        imageView.image = building.image;
        self.leftCalloutAccessoryView = imageView;
    } else {
        self.leftCalloutAccessoryView = nil;
    }
}


@end
