//
//  UHDMainMensaViewController.h
//  uni-hd
//
//  Created by Felix on 03.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDDailyMenu.h"

@interface UHDMainMensaViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *DailyMenuViewContainer;
@property (strong, nonatomic) UHDDailyMenu *dailyMenu;


@end
