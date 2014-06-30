//
//  UHDTalk.h
//  uni-hd
//
//  Created by Kevin Geier on 30.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDEventItem.h"

@interface UHDTalkItem : UHDEventItem

@property (nonatomic, retain) NSString *speaker;
@property (nonatomic, retain) NSString *speakerOrigin;

@end
