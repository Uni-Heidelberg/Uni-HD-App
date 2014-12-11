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

- (IBAction)refreshControlValueChanged:(id)sender;

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
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
    
    [self configureView];
}

- (void)configureView
{
    if (!self.mensa) {
        self.emptyViewLabel.text = NSLocalizedString(@"Wähle eine Mensa.", nil);
        self.tableView.tableHeaderView = self.emptyView;
    } else if (!self.date) {
        self.emptyViewLabel.text = NSLocalizedString(@"Wähle ein Datum.", nil);
        self.tableView.tableHeaderView = self.emptyView;
    } else if (![self.mensa hasMenuForDate:self.date]) {
        if ([[NSCalendar currentCalendar] isDateInWeekend:self.date]) { // TODO: make this dynamic by checking mensa's hours when implemented
            self.emptyViewLabel.text = NSLocalizedString(@"Feiertag!", nil);
        } else {
            self.emptyViewLabel.text = NSLocalizedString(@"Kein Speiseplan verfügbar.", nil);
        }
        self.tableView.tableHeaderView = self.emptyView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController)
    {
        if (!self.mensa.managedObjectContext) {
            [self.logger log:@"Unable to create fetched results controller without a managed object context." forLevel:VILogLevelWarning];
            return nil;
        }
        
        if (!(self.mensa && self.date)) {
            [self.logger log:@"Mensa and date need to be set to create fetched results controller." forLevel:VILogLevelWarning];
            return nil;
        }
        
        // Get date range for set date
        NSDate *startDate;
        NSTimeInterval dayLength;
        [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&startDate interval:&dayLength forDate:self.date];
        NSDate *endDate = [startDate dateByAddingTimeInterval:dayLength];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDDailyMenu entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"section.title" ascending:YES]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"section.mensa == %@ AND date >=%@ AND date <= %@", self.mensa, startDate, endDate];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.mensa.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        [_fetchedResultsController performFetch:nil];
    }
    
    return _fetchedResultsController;
}


#pragma mark - User Interaction

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UHDMeal *meal = [self mealForIndexPath:indexPath];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle: meal.isFavourite ? NSLocalizedString(@"Favorit Markierung entfernen", nil) : NSLocalizedString(@"Als Favorit markieren", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        meal.isFavourite = !meal.isFavourite;
        [meal.managedObjectContext saveToPersistentStore:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Abbrechen", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)refreshControlValueChanged:(UIRefreshControl *)sender
{
    [[[UHDRemoteDatasourceManager defaultManager] remoteDatasourceForKey:UHDRemoteDatasourceKeyMensa] refreshWithCompletion:^(BOOL success, NSError *error) {
        [sender endRefreshing];
    }];
}

#pragma mark - Index Path to Model Conversion

- (NSOrderedSet *)mealsInSection:(NSInteger)section {
    UHDDailyMenu *dailyMenu = [self.fetchedResultsController.fetchedObjects objectAtIndex:section];
    return dailyMenu.meals;
}

- (UHDMeal *)mealForIndexPath:(NSIndexPath *)indexPath {
    return [[self mealsInSection:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSIndexPath *)indexPathForMeal:(UHDMeal *)meal {
    for (int section=0; section<[self numberOfSectionsInTableView:self.tableView]; section++) {
        NSUInteger row = [[self mealsInSection:section] indexOfObject:meal];
        if (row!=NSNotFound) {
            return [NSIndexPath indexPathForRow:row inSection:section];
        }
    }
    return nil;
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
    return [self mealsInSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UHDMealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mealCell" forIndexPath:indexPath];
    UHDMeal *meal = [self mealForIndexPath:indexPath];
    
    [cell configureForMeal:meal];
    //cell.delegate = self;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    UHDDailyMenu *dailyMenu = [self.fetchedResultsController.fetchedObjects objectAtIndex:section];
    return [NSString stringWithFormat:NSLocalizedString(@"Ausgabe %@", nil), dailyMenu.section.title];
}


#pragma mark - Managed Object Context Save Notification

- (void)managedObjectContextDidSave:(NSNotification *)notification {
    // FIXME: some exceptions are thrown here...
    NSSet *updatedObjects = (NSSet *)notification.userInfo[NSUpdatedObjectsKey];
    for (NSManagedObject *updatedObject in updatedObjects) {
        if (![updatedObject.entityName isEqualToString:[UHDMeal entityName]]) {
            continue;
        }
        NSIndexPath *indexPath = [self indexPathForMeal:(UHDMeal *)updatedObject];
        if (indexPath) {
            [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

/*#pragma mark - Swipe Table View Cell Delegate

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
        UHDMeal *meal = [self mealForIndexPath:[self.tableView indexPathForCell:swipeTableViewCell]];
        meal.isFavourite = !meal.isFavourite;
        [meal.managedObjectContext saveToPersistentStore:nil];
    }
}

-(void)swipeTableViewCellDidResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellDidResetState: %@ fromPoint: %@ animation: %u, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
}*/


@end
