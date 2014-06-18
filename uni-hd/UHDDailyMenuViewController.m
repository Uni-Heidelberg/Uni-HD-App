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

#define LOG_DELEGATE_METHODS 0


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
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"section.remoteObjectId" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"menu == %@", self.dailyMenu];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.dailyMenu.managedObjectContext
            sectionNameKeyPath:@"section.title" cacheName:nil];
        
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, id item) {
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
#if LOG_DELEGATE_METHODS
    NSLog(@"swipeTableViewCellDidStartSwiping: %@", swipeTableViewCell);
#endif
}

-(void)swipeTableViewCell:(UHDMealCell *)swipeTableViewCell didSwipeToPoint:(CGPoint)point velocity:(CGPoint)velocity {
#if LOG_DELEGATE_METHODS
    NSLog(@"swipeTableViewCell: %@ didSwipeToPoint: %@ velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), NSStringFromCGPoint(velocity));
#endif
}

-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
#if LOG_DELEGATE_METHODS
    NSLog(@"swipeTableViewCellWillResetState: %@ fromPoint: %@ animation: %d, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity));
#endif
    if (-point.x >= CGRectGetHeight(swipeTableViewCell.frame)) {
        if (((UHDMealCell *)swipeTableViewCell).isFavourite) {
            ((UHDMealCell *)swipeTableViewCell).isFavourite = NO;
        } else {
            ((UHDMealCell *)swipeTableViewCell).isFavourite = YES;
        }
        [(UHDMealCell *)swipeTableViewCell setFavourite: ((UHDMealCell *)swipeTableViewCell).isFavourite animated:YES];
        }
    
}

-(void)swipeTableViewCellDidResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
#if LOG_DELEGATE_METHODS
    NSLog(@"swipeTableViewCellDidResetState: %@ fromPoint: %@ animation: %d, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity));
#endif
}


@end
