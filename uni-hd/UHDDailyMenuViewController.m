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
#import "RMSwipeTableViewCell.h"


@interface UHDDailyMenuViewController ()

@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

@property (strong, nonatomic) IBOutlet UIView *emptyView;

- (void)configureView;

@end


@implementation UHDDailyMenuViewController

- (void)setDailyMenu:(UHDDailyMenu *)dailyMenu
{
    if (_dailyMenu == dailyMenu) return;
    _dailyMenu = dailyMenu;
    self.fetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"menu == %@", self.dailyMenu];
    [self.fetchedResultsControllerDataSource reloadData];
    [self configureView];
}

- (NSDate *)date
{
    if (self.dailyMenu) {
        return self.dailyMenu.date;
    } else {
        return _date;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // redirect datasource
    self.tableView.dataSource = self.fetchedResultsControllerDataSource;
    
    [self configureView];
}

- (void)configureView
{
    self.tableView.tableHeaderView = self.dailyMenu ? nil : self.emptyView;
}

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource {
    if (!_fetchedResultsControllerDataSource)
    {
        if (!self.dailyMenu.managedObjectContext) {
            [self.logger log:@"Unable to create fetched results controller without a managed object context" forLevel:VILogLevelWarning];
            return nil;
        }

        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMeal entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"section.remoteObjectId" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"menu == %@", self.dailyMenu];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.dailyMenu.managedObjectContext
            sectionNameKeyPath:@"section.title" cacheName:nil];
        
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, id item) {
            ((UHDMealCell *)cell).meal = (UHDMeal *)item;
            [(UHDMealCell *)cell configureForMeal:(UHDMeal *)item];
            __weak UHDDailyMenuViewController *weakSelf = self;
            [(UHDMealCell *)cell setDelegate: weakSelf];

        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"mealCell" configureCellBlock:configureCellBlock];
        
    }
    return _fetchedResultsControllerDataSource;
}


#pragma mark - Swipe Table View Cell Delegate

-(void)swipeTableViewCellDidStartSwiping:(RMSwipeTableViewCell *)swipeTableViewCell {
    [self.logger log:@"swipeTableViewCellDidStartSwiping: %@" object:swipeTableViewCell forLevel:VILogLevelVerbose];
}

-(void)swipeTableViewCell:(UHDMealCell *)swipeTableViewCell didSwipeToPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCell: %@ didSwipeToPoint: %@ velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
}

-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellWillResetState: %@ fromPoint: %@ animation: %lu, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
    if (-point.x >= CGRectGetHeight(swipeTableViewCell.frame)) {
        if (((UHDMealCell *)swipeTableViewCell).meal.isFavourite) {
            ((UHDMealCell *)swipeTableViewCell).meal.isFavourite = NO;
        } else {
            ((UHDMealCell *)swipeTableViewCell).meal.isFavourite = YES;
        }
        [(UHDMealCell *)swipeTableViewCell setFavourite:((UHDMealCell *)swipeTableViewCell).meal.isFavourite animated:YES];
        }
    
}

-(void)swipeTableViewCellDidResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellDidResetState: %@ fromPoint: %@ animation: %lu, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
}


@end
