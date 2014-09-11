//
//  UHDMapsRemoteDatasourceDelegate.h
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteDatasource.h"

@interface UHDMapsRemoteDatasourceDelegate : NSObject <UHDRemoteDatasourceDelegate>

- (UIImage *)overlayImageForUrl:(NSURL *)overlayImageURL;

@end
