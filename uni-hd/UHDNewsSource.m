//
//  UHDNewsSource.m
//  uni-hd
//
//  Created by Kevin Geier on 19.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsSource.h"

@implementation UHDNewsSource

@dynamic subscribed;
@dynamic title;
@dynamic imageURL, imageData;
@dynamic newsItems;
@dynamic associatedBuildings;

@dynamic isNewsSource, isEventSource;

- (NSMutableSet *)mutableNewsItems {
    return [self mutableSetValueForKey:@"newsItems"];
}

- (NSMutableSet *)mutableAssociatedBuildings {
    return [self mutableSetValueForKey:@"associatedBuildings"];
}

- (int)subscribedCount {
    return (self.subscribed ? 1 : 0) + [super subscribedCount];
}

#pragma mark - Convenience accessors

- (UIImage *)image
{
    if (self.imageData) {
        return [UIImage imageWithData:self.imageData];
    } else if (self.imageURL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if ([(NSHTTPURLResponse *)response statusCode]==200) {
                self.imageData = data;
            }
        }];
        return nil;
    } else {
        return nil;
    }
}

- (UHDNewsCategory *)category
{
	return self.parent;
}

- (void)setCategory:(UHDNewsCategory *)category
{
	self.parent = category;
}


@end
