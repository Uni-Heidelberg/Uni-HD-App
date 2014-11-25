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
#import "UHDDailyMenu.h"
#import "UHDMensaSection.h"



@interface UHDDailyMenuViewController () <RMSwipeTableViewCellDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UILabel *emptyViewLabel;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)configureView;

@end


@implementation UHDDailyMenuViewController

- (void)setMensa:(UHDMensa *)mensa
{
    if (_mensa == mensa) return;
    _mensa = mensa;
    [self configureView];
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    [self configureView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
}

- (void)configureView
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.emptyViewLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Menu unavailable for %@", nil), [dateFormatter stringFromDate:self.date]];
    self.tableView.tableHeaderView = (self.mensa && self.date) ? nil : self.emptyView;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController)
    {
        if (!self.mensa.managedObjectContext) {
            [self.logger log:@"Unable to create fetched results controller without a managed object context" forLevel:VILogLevelWarning];
            return nil;
        }
        NSDate *startDate;
        NSTimeInterval dayLength;
        [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&startDate interval:&dayLength forDate:self.date];
        NSDate *endDate = [startDate dateByAddingTimeInterval:dayLength];
        
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDDailyMenu entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"section.remoteObjectId" ascending:YES]];
        //TODO: add meal title sorting
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"section.mensa == %@ AND date >=%@ AND date <= %@", self.mensa, startDate, endDate];
        
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.mensa.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        [_fetchedResultsController performFetch:nil];
        
    }
    
    return _fetchedResultsController;
    
    //  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(menus, $menu, $menu.section.mensa == %@ AND ($menu.date >= %@) AND ($menu.date <= %@)).@count > 0", self.mensa, startDate, endDate];
    
    
}



#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!(self.mensa && self.date)) return 0;
    
    return self.fetchedResultsController.fetchedObjects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!(self.mensa && self.date)) return 0;
    UHDDailyMenu* dailyMenu = [self.fetchedResultsController.fetchedObjects objectAtIndex:section];
    return dailyMenu.meals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id cell = [tableView dequeueReusableCellWithIdentifier:@"mealCell"  forIndexPath:indexPath];
    UHDDailyMenu * dailyMenu = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.section];
    NSArray * meals = [dailyMenu.meals sortedArrayUsingDescriptors: @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    UHDMeal * meal = [meals objectAtIndex:indexPath.row];
    
    [(UHDMealCell *)cell configureForMeal:meal];
    [(UHDMealCell *)cell setDelegate:self];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: test efficiency
    
    UHDMealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mealCell"];
    UHDDailyMenu * dailyMenu = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.section];
    NSArray * meals = [dailyMenu.meals sortedArrayUsingDescriptors: @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    UHDMeal * meal = [meals objectAtIndex:indexPath.row];
    [cell configureForMeal:meal];
    [cell layoutIfNeeded];
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.; // TODO: remove + 1.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    UHDDailyMenu * dailyMenu = [self.fetchedResultsController.fetchedObjects objectAtIndex:section];
    return dailyMenu.section.title;
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
        UHDMeal *meal = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:swipeTableViewCell]];
        
        meal.isFavourite = !meal.isFavourite;
        [meal.managedObjectContext saveToPersistentStore:nil];
    }
}

-(void)swipeTableViewCellDidResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellDidResetState: %@ fromPoint: %@ animation: %u, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
}


@end
