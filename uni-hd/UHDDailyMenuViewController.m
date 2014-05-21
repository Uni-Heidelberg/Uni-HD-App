//
//  UHDDailyMenuViewController.m
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDDailyMenuViewController.h"
#import "UHDMensa.h"
#import "UHDMealCell.h"
#import "UHDMealCell+ConfigureForItem.h"
#import "VIFetchedResultsControllerDataSource.h"


@interface UHDDailyMenuViewController ()

@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

@end

@implementation UHDDailyMenuViewController


- (void)configureView
{
    self.title = self.dailyMenu.mensa.title;
    [self.tableView reloadData];
}
- (void)setDailyMenu:(UHDDailyMenu *)dailyMenu
{
    if (_dailyMenu == dailyMenu) return;
    _dailyMenu = dailyMenu;
    [self configureView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    // redirect datasource
    self.tableView.dataSource = self.fetchedResultsControllerDataSource;
}

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource {
    if (!_fetchedResultsControllerDataSource) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMeal entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"menu == %@", self.dailyMenu];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                   managedObjectContext:self.dailyMenu.managedObjectContext
                                                                                                     sectionNameKeyPath:nil
                                                                                                              cacheName:nil];
        
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, id item) {
            [(UHDMealCell *)cell configureForMeal:(UHDMeal *)item];
        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"mealCell" configureCellBlock:configureCellBlock];
        
    }
    return _fetchedResultsControllerDataSource;
}


@end
