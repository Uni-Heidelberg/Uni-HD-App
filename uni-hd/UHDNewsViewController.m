//
//  UHDNewsViewController.m
//  uni-hd
//
//  Created by Nils Fischer on 06.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsDetailViewController.h"
#import "UHDNewsViewController.h"
#import "UHDNewsStore.h"
#import "UHDNewsItem.h"
#import "VIFetchedResultsControllerDataSource.h"

@interface UHDNewsViewController ()

@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

- (IBAction)makeSamplesButtonPressed:(id)sender;

@end

@implementation UHDNewsViewController

- (IBAction)makeSamplesButtonPressed:(id)sender {

    [[UHDNewsStore defaultStore] generateSampleData];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"News", nil);
    
    // redirect data source
    self.tableView.dataSource = self.fetchedResultsControllerDataSource;
    
}

#pragma mark - Data Source

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
    if (!_fetchedResultsControllerDataSource)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsItem entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[UHDNewsStore defaultStore].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, UHDNewsItem *item) {
            cell.textLabel.text = item.title;
        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"newsCell" configureCellBlock:configureCellBlock];
    }
    return _fetchedResultsControllerDataSource;
}


#pragma mark - Seque

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UHDNewsItem *selectedNewsItem = self.fetchedResultsControllerDataSource.selectedItem;
    
    UHDNewsDetailViewController *NewsDetailVC = segue.destinationViewController;
    
    NewsDetailVC.newsItem = selectedNewsItem;
    
    // [self.logger log:@"Segue selected" forLevel:VILogLevelDebug];
    
}


@end
