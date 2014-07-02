//
//  UHDMensaDetailViewController.m
//  uni-hd
//
//  Created by Felix on 25.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaDetailViewController.h"

@interface UHDMensaDetailViewController ()
@property int headerImageYOffset;
@property UIImageView* headerImage;

@end

@implementation UHDMensaDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 180.0)];
    UIView *blackBorderView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 179.0, self.view.frame.size.width, 1.0)];
    blackBorderView.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.8];
    [tableHeaderView addSubview: blackBorderView];
    
    self.tableView.tableHeaderView = tableHeaderView;
    
    
    // Create the underlying imageview and offset it
    //self.headerImageYOffset = -150.0;
    CGRect headerImageFrame = tableHeaderView.frame;
    //headerImageFrame.origin.y = self.headerImageYOffset;
    self.headerImage.frame = headerImageFrame;
    self.headerImage.backgroundColor = [UIColor redColor];
    self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *image = [UIImage imageNamed: @"marstallhof-01"];
    [self.headerImage setImage:image];
    [self.view insertSubview: self.headerImage belowSubview: self.tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGRect headerImageFrame = self.headerImage.frame;
    
    if (scrollOffset < 0) {
        // Adjust image proportionally
        headerImageFrame.origin.y = self.headerImageYOffset - ((scrollOffset / 3));
    } else {
        // We're scrolling up, return to normal behavior
        headerImageFrame.origin.y = self.headerImageYOffset - scrollOffset;
    }
    self.headerImage.frame = headerImageFrame;
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
