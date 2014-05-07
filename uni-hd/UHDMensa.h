//
//  UHDMensa.h
//  uni-hd
//
//  Created by Nils Fischer on 07.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UHDMensa : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSManagedObject *location;

@end
