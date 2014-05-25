//
//  UHDNewsCategoryViewController.m
//  uni-hd
//
//  Created by Andreas Schachner on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsCategoryViewController.h"
#import "UHDNewsCategoryCell.h"
#import "UHDNewsCategory.h"
#import "UHDNewsSource.h"
#import "VIFetchedResultsControllerDataSource.h"
#import "UHDNewsCategoryCell.h"
#import "UHDNewsCategoryCell+ConfigureForCategory.h"
#import "UHDNewsCategorySourceCell+ConfigureForCategorySource.h"

@interface UHDNewsCategoryViewController ()

@property (strong, nonatomic) id <UHDRemoteDatasource> remoteDatasource;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation UHDNewsCategoryViewController

- (void)setRemoteDatasource:(id<UHDRemoteDatasource>)remoteDatasource
{
    _remoteDatasource = remoteDatasource;
}
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Category", nil);

}

@end
