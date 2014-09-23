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
#import "VIFetchedResultsControllerDataSource.h"


@interface UHDDailyMenuViewController () <RMSwipeTableViewCellDelegate>

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
        
        __weak UHDDailyMenuViewController *weakSelf = self;
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, id item) {
            [(UHDMealCell *)cell configureForMeal:(UHDMeal *)item];
            [(UHDMealCell *)cell setDelegate:weakSelf];
        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"mealCell" configureCellBlock:configureCellBlock];
        
    }
    return _fetchedResultsControllerDataSource;
}


#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsControllerDataSource numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsControllerDataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsControllerDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: test efficiency
    UHDMealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mealCell"];
    [cell configureForMeal:[self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath]];
    [cell layoutIfNeeded];
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.; // TODO: remove + 1.
}

#pragma mark - Swipe Table View Cell Delegate

-(void)swipeTableViewCellDidStartSwiping:(RMSwipeTableViewCell *)swipeTableViewCell {
    [self.logger log:@"swipeTableViewCellDidStartSwiping: %@" object:swipeTableViewCell forLevel:VILogLevelVerbose];
}

-(void)swipeTableViewCell:(UHDMealCell *)swipeTableViewCell didSwipeToPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCell: %@ didSwipeToPoint: %@ velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
}

-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity
{
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellWillResetState: %@ fromPoint: %@ animation: %u, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];

    if ([(UHDFavouriteCell *)swipeTableViewCell shouldTriggerForPoint:point]) {
        UHDMeal *meal = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:swipeTableViewCell]];
        
        meal.isFavourite = !meal.isFavourite;
        [meal.managedObjectContext saveToPersistentStore:nil];
    }
}

-(void)swipeTableViewCellDidResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellDidResetState: %@ fromPoint: %@ animation: %u, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
}


@end
