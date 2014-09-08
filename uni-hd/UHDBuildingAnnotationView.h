//
//  UHDBuildingAnnotationView.h
//  uni-hd
//
//  Created by Nils Fischer on 07.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "UHDBuilding.h"

@interface UHDBuildingAnnotationView : MKAnnotationView

@property (strong, nonatomic) UHDBuilding *annotation;

- (id)initWithAnnotation:(UHDBuilding *)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
