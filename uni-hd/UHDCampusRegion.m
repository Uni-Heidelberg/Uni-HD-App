//
//  UHDCampusRegion.m
//  uni-hd
//
//  Created by Andreas Schachner on 27.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDCampusRegion.h"

@implementation UHDCampusRegion

@dynamic title, identifier;
@dynamic buildings;
@dynamic overlayBottomLeftCoordinate, overlayBottomRightCoordinate, overlayTopLeftCoordinate,overlayTopRightCoordinate;


#pragma mark - Mutable To-Many Accessors

- (NSMutableSet *)mutableBuildings
{
    return [self mutableSetValueForKey:@"buildings"];
}

@end
