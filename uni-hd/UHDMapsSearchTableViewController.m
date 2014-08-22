//
//  UHDMapsSearchTableViewController.m
//  uni-hd
//
//  Created by Andreas Schachner on 13.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMapsSearchTableViewController.h"
#import "VIFetchedResultsControllerDataSource.h"
#import "UHDRemoteDatasourceManager.h"

//Model
#import "UHDBuilding.h"
#import "UHDRemoteManagedLocation.h"
//#import "UHDBuildingsCategory.h"

#import "UHDMapsSearchCell+ConfigureForItem.h"
#import "UHDMapsSearchCell.h"


@interface UHDMapsSearchTableViewController ()

@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation UHDMapsSearchTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
}

- (void)configureView
{
    self.title = @"Suche";

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

}

//-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    
  //  managedObjectContext = [(UHDBuilding *)building managedObjectContext];

//}

#pragma mark - Data Source

-(void)setBuildingsList:(NSArray *)buildingsList{
    
    buildingsList = self.fetchedResultsControllerDataSource.fetchedResultsController.fetchedObjects;
    
    //self.fetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"building IN %@", buildingsList];
    //[self.fetchedResultsControllerDataSource reloadData];
    
    [self configureView];
    
}

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
    if (!_fetchedResultsControllerDataSource) {
        
    if (!self.managedObjectContext) {
       [self.logger log:@"Unable to create fetched results controller without a managed object context" forLevel:VILogLevelWarning];
        return nil;
   }
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDBuilding entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        [fetchedResultsController performFetch:NULL];
        
        
        //NSFetchedResultController mit Category
    
        //NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDBuilding entityName]];
    
        //fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"category.remoteObjectId" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        
        //NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"category.title" cacheName:nil];
        
        //[fetchedResultsController performFetch:NULL];
        
        
		VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] init];
		fetchedResultsControllerDataSource.tableView = self.tableView;
		fetchedResultsControllerDataSource.fetchedResultsController = fetchedResultsController;
        self.fetchedResultsControllerDataSource = fetchedResultsControllerDataSource;

    }
    
	return _fetchedResultsControllerDataSource;
}

#pragma mark - Table View Datasource


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
  //  return [[self.fetchedResultsController sections] count];
//}



//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//	return [self.fetchedResultsControllerDataSource tableView:tableView numberOfRowsInSection:section];
//}

//- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection { id<NSFetchedResultsSectionInfo> theInfo = [[self.fetchedResultsController sections] objectAtIndex:inSection];
  //  return [theInfo numberOfObjects];
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsControllerDataSource.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsControllerDataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
    
		UHDBuilding *item = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
        
		cell = [tableView dequeueReusableCellWithIdentifier:@"mapsSearchCell" forIndexPath:indexPath];
		[(UHDMapsSearchCell *)cell configureForItem:item];

	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.fetchedResultsControllerDataSource tableView:tableView titleForHeaderInSection:section];
}





@end
