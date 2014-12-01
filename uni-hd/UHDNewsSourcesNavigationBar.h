//
//  UHDNewsSourcesNavigationBar.h
//  uni-hd
//
//  Created by Kevin Geier on 08.11.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDNewsSource.h"

@protocol UHDNewsSourcesNavigationBarDelegate;


@interface UHDNewsSourcesNavigationBar : UIView

@property (weak, nonatomic) id<UHDNewsSourcesNavigationBarDelegate> delegate;

// (subscribed) sources to display in menu bar (attribute is set by News View Controller)
@property (strong, nonatomic) NSArray *sources;

// currently selected source
@property (strong, nonatomic) UHDNewsSource *selectedSource;

// width of collection view cells
@property (nonatomic) CGFloat itemWidth;

@end


@protocol UHDNewsSourcesNavigationBarDelegate

- (void)sourcesNavigationBar:(UHDNewsSourcesNavigationBar *)navigationBar didSelectSource:(UHDNewsSource *)source;

@end
