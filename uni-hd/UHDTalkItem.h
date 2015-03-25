//
//  UHDTalk.h
//  uni-hd
//
//  Created by Kevin Geier on 30.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import Foundation;
#import "UHDEventItem.h"
@class UHDTalkSpeaker;

@interface UHDTalkItem : UHDEventItem

@property (nonatomic, retain) UHDTalkSpeaker *speaker;

@end
