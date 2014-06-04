//
//  UHDSection.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"

@class UHDMeal, UHDMensa;

@interface UHDMensaSection : UHDRemoteManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *meals;
@property (nonatomic, retain) UHDMensa *mensa;

@end

