//
//  UHDBuildingDetailViewController.m
//  uni-hd
//
//  Created by Andreas Schachner on 01.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDBuildingDetailViewController.h"
#import "UHDLocationCategory.h"

@interface UHDBuildingDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (void)configureView;

@end

@implementation UHDBuildingDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.headerImageView.image = self.building.image;
    
    // TODO: fix imageframe at startup
    //    CGRect imageFrame = self.mensaPicture.frame;
    //    imageFrame.size.height = self.tableView.tableHeaderView.frame.size.height;
    //    self.mensaPicture.frame = imageFrame;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // TODO: fix imageframe at startup
    [self scrollViewDidScroll:self.tableView];
}

- (void)setBuilding:(UHDBuilding *)building
{
    _building = building;
    [self configureView];
}

-(void)configureView
{
    if (self.building) {
        self.title = self.building.title;
        self.identifierLabel.text = self.building.campusIdentifier;
        self.categoryLabel.text = self.building.category.title;
        self.headerImageView.image = self.building.image;
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotation:self.building];
        [self.mapView showAnnotations:@[ self.building ] animated:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGRect imageFrame = self.headerImageView.frame;
    imageFrame.origin.y = offset;
    imageFrame.size.height = - offset + self.tableView.tableHeaderView.frame.size.height;
    self.headerImageView.frame = imageFrame;
}

@end
