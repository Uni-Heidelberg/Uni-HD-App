//
//  UHDMensa.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UHDBuilding.h"
@class Hours;

@interface UHDMensa : UHDBuilding

@property (nonatomic, assign) BOOL isFavourite;
@property (readonly) Hours *hours; // TODO: not yet implemented properly
@property (readonly) NSAttributedString *attributedStatusDescription;

@property (nonatomic, retain) NSSet *sections;
- (NSMutableSet *)mutableSections;

- (BOOL)hasMenuForDate:(NSDate *)date;

@end


