//
//  UHDBuildingAnnotationView.h
//  uni-hd
//
//  Created by Nils Fischer on 07.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <MapKit/MapKit.h>
@class Building;

@interface UHDBuildingAnnotationView : MKAnnotationView

@property (strong, nonatomic) Building *annotation;
@property (nonatomic) BOOL shouldHideImage;

- (id)initWithAnnotation:(Building *)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
