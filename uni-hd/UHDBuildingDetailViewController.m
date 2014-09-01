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

-(void)configureView;

@end

@implementation UHDBuildingDetailViewController

@synthesize building=_building;
@synthesize category=_category;

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
    
    // Configure text
    self.titleLabel.text = self.building.title;
    self.subtitleLabel.text = self.building.identifier;
    self.buildingCategoryLabel.text = self.category.title;
    
    // Configure Image
    self.buildingsImageView.image = self.building.image;
    
    [self configureView];
}

-(void)setBuilding:(UHDBuilding *)building
{
    _building = building;
    [self configureView];
}
-(UHDBuilding *)building
{
    return _building;
}
-(void)setCategory:(UHDLocationCategory *)category
{
    category = self.building.category;
    _category = category;
    [self configureView];
}
-(UHDLocationCategory *)category
{
    return _category;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void)configureView{
   self.title = @"Informationen";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
