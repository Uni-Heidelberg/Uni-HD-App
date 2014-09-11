//
//  UHDBuilding.m
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDBuilding.h"

#import "UHDCampusRegion.h"

@implementation UHDBuilding

@dynamic category;
@dynamic campusRegion, buildingNumber;
@dynamic addressDictionary;
@dynamic imageData;


#pragma mark - Computed Properties

- (NSString *)campusIdentifier {
    return [NSString stringWithFormat:@"%@ %@", self.campusRegion.identifier, self.buildingNumber];
}

- (UIImage *)image {
    return [UIImage imageWithData:self.imageData];
}

- (void)setImage:(UIImage *)image {
    self.imageData = UIImageJPEGRepresentation(image, 1);
}

#pragma mark - MKAnnotation Protocol

// mostly inherited from UHDRemoteManagedLocation

- (NSString *)subtitle {
    return self.campusIdentifier;
}

@end
