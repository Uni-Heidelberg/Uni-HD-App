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

- (void)configureForMenu:(UHDDailyMenu *)dailyMenu;

@end


@implementation UHDDailyMenuViewController

- (void)setDailyMenu:(UHDDailyMenu *)dailyMenu
{
    if (_dailyMenu == dailyMenu) return;
    _dailyMenu = dailyMenu;
    [self configureForMenu:dailyMenu];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // redirect datasource
    self.tableView.dataSource = self.fetchedResultsControllerDataSource;

    [self configureForMenu:self.dailyMenu];
}

- (void)configureForMenu:(UHDDailyMenu *)dailyMenu
{
    self.title = dailyMenu.mensa.title;
    self.fetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"menu == %@", dailyMenu];
    [self.fetchedResultsControllerDataSource reloadData];
    [self.tableView reloadData];


}


- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource {
    if (!self.dailyMenu) return nil;
    if (!_fetchedResultsControllerDataSource) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMeal entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"menu == %@", self.dailyMenu];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.dailyMenu.managedObjectContext
            sectionNameKeyPath:nil cacheName:nil];
        
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, id item) {
            [(UHDMealCell *)cell configureForMeal:(UHDMeal *)item];
        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"mealCell" configureCellBlock:configureCellBlock];
        
    }
    return _fetchedResultsControllerDataSource;
}

- (void)selectMense:(UHDMensa *)mensa
{
    
}


@end
