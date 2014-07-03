//
//  UHDMensaDetailViewController.m
//  uni-hd
//
//  Created by Felix on 25.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaDetailViewController.h"
#import "UHDLocation.h"

@interface UHDMensaDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *mensaPicture;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation UHDMensaDetailViewController

@synthesize mensa = _mensa;

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
    [self configureView];
}
-(void)setMensa:(UHDMensa *)mensa
{
    _mensa = mensa;
    [self configureView];
}
-(UHDMensa *)mensa
{
    return _mensa;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    // TODO: fix imageframe at startup
//    CGRect imageFrame = self.mensaPicture.frame;
//    imageFrame.size.height = self.tableView.tableHeaderView.frame.size.height;
//    self.mensaPicture.frame = imageFrame;

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   [self scrollViewDidScroll:self.tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGRect imageFrame = self.mensaPicture.frame;
    imageFrame.origin.y = offset;
    imageFrame.size.height = - offset + self.tableView.tableHeaderView.frame.size.height;
    self.mensaPicture.frame = imageFrame;
}

- (void)configureView
{
    self.title = self.mensa.title;
    [self.mapView setRegion: MKCoordinateRegionMake(self.mensa.coordinate, MKCoordinateSpanMake(0.005, 0.005))];
    [self.mapView addAnnotation:self.mensa];
}


@end