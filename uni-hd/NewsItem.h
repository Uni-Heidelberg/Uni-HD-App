//
//  NewsItem.h
//  uni-hd
//
//  Created by Nils Fischer on 06.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewsItem : NSManagedObject

@property (nonatomic, retain) NSString *title;

@end
