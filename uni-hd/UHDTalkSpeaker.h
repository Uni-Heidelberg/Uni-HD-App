//
//  UHDTalkSpeaker.h
//  uni-hd
//
//  Created by Kevin Geier on 02.07.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import UHDRemoteKit;
@class UHDTalkItem;

@interface UHDTalkSpeaker : UHDRemoteManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *affiliation;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) UHDTalkItem *talk;

@end
