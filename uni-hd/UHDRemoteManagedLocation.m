//
//  UHDLocation.m
//  uni-hd
//
//  Created by Nils Fischer on 08.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedLocation.h"

@implementation UHDRemoteManagedLocation

@dynamic title;
@dynamic latitude, longitude;
@dynamic category;
@dynamic imageData;


#pragma mark - MKAnnotation Protocol

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (UIImage *)image {
    return [UIImage imageWithData:self.imageData];
}

- (void)setImage:(UIImage *)image {
    self.imageData = UIImageJPEGRepresentation(image, 1);
}

@end
