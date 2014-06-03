//
//  UHDMainMensaViewController.m
//  uni-hd
//
//  Created by Felix on 03.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMainMensaViewController.h"
#import "UHDDailyMenuViewController.h"


@interface UHDMainMensaViewController ()

@end

@implementation UHDMainMensaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UHDDailyMenuViewController *dailyMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DailyMenuViewController"];
    dailyMenuVC.dailyMenu = self.dailyMenu;
    [self addChildViewController:dailyMenuVC];
    [self.DailyMenuViewContainer addSubview:dailyMenuVC.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
