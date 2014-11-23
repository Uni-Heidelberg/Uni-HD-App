//
//  UHDNewsSourcesNavigationBar.h
//  uni-hd
//
//  Created by Kevin Geier on 08.11.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDNewsSource.h"

@interface UHDNewsSourcesNavigationBar : UIView

// (subscribed) sources to display in menu bar (attribute is set by News View Controller)
@property (strong, nonatomic) NSArray *sources;


// TODO: find better representation of selected source


// index of currently selected source
@property (nonatomic) NSUInteger selectedSourceIndex;

// width of collection view cells
@property (nonatomic) CGFloat itemWidth;

@end
