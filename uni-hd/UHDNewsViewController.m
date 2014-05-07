//
//  UHDNewsViewController.m
//  uni-hd
//
//  Created by Nils Fischer on 06.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsViewController.h"
#import "UHDNewsStore.h"
#import "VIFetchedResultsControllerDataSource.h"

@interface UHDNewsViewController ()

@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

@end

@implementation UHDNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // redirect data source
    self.tableView.dataSource = self.fetchedResultsControllerDataSource;
    
}

# pragma mark - Data Source

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
    if (!_fetchedResultsControllerDataSource)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"NewsItem"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.store.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, NSManagedObject *item) {
            cell.textLabel.text = [item valueForKey:@"title"];
        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"newsCell" configureCellBlock:configureCellBlock];
    }
    return _fetchedResultsControllerDataSource;
}

@end
