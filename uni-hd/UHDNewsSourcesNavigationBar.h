//
//  UHDNewsSourcesNavigationBar.h
//  uni-hd
//
//  Created by Kevin Geier on 08.11.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHDNewsSourcesNavigationBar : UIView

// (subscribed) sources to display in menu bar (attribute is set by News View Controller)
@property (strong, nonatomic) NSArray *sources;

// width of collection view cells
@property (nonatomic) CGFloat itemWidth;

@end
