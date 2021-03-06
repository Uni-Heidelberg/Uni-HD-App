//
//  UHDAppDelegate.h
//  uni-hd
//
//  Created by Nils Fischer on 24.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import Foundation;
@import UIKit;
@import EventKit;


@interface UHDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) EKEventStore *eventStore;

@end
