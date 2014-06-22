//
//  UHDMapsViewController.m
//  uni-hd
//
//  Created by Nils Fischer on 22.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMapsViewController.h"

@interface UHDMapsViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation UHDMapsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(49.418976, 8.670292), MKCoordinateSpanMake(0.01, 0.01));
}

@end
