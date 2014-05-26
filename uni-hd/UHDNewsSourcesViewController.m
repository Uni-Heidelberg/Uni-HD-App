//
//  UHDNewsCategoryViewController.m
//  uni-hd
//
//  Created by Andreas Schachner on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsSourcesViewController.h"
#import "VIFetchedResultsControllerDataSource.h"

// Model
#import "UHDNewsSource.h"

// Table View Cells
#import "UHDNewsSourceCell.h"
#import "UHDNewsSourceCell+ConfigureForSource.h"


@interface UHDNewsSourcesViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

@end


@implementation UHDNewsSourcesViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // redirect datasource
    self.tableView.dataSource = self.fetchedResultsControllerDataSource;
}


#pragma mark - Data Source

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
    if (!_fetchedResultsControllerDataSource)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsSource entityName]];
        fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"category.title" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO] ];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, id item) {
            [(UHDNewsSourceCell *)cell configureForSource:item];
        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"newsSourceCell" configureCellBlock:configureCellBlock];
    }
    return _fetchedResultsControllerDataSource;
}

@end
