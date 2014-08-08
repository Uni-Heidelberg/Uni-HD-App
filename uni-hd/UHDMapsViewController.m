//
//  UHDMapsViewController.m
//  uni-hd
//
//  Created by Nils Fischer on 22.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMapsViewController.h"
#import "VIFetchedResultsControllerDataSource.h"
#import "UHDRemoteDatasourceManager.h"

//Model
#import "UHDBuilding.h"
#import "UHDLocationPoints.h"



@interface UHDMapsViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) UHDBuilding *building;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (NSMutableArray *)createAnnotations;

@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;


@end

@implementation UHDMapsViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(49.418976, 8.670292), MKCoordinateSpanMake(0.01, 0.01));
    
    [self.mapView addAnnotations:[self createAnnotations]];
    [self.mapView showAnnotations:self.createAnnotations animated:YES];
    [self.mapView regionThatFits:self.mapView.region];
    

}



- (NSMutableArray *)createAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    UHDBuilding *annotation = [[UHDBuilding alloc] initWithTitle:self.building.title AndCoordinate:self.building.coordinate];
        [annotations addObject:annotation];
    
    return annotations;
}


@end
