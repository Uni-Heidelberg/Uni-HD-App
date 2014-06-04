//
//  UHDMensaViewController.m
//  uni-hd
//
//  Created by Felix on 07.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaViewController.h"
#import "UHDDailyMenuViewController.h"
#import "UHDLocation.h"
#import "UHDMensa.h"
#import "VIFetchedResultsControllerDataSource.h"


@interface UHDMensaViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

@property (strong, nonatomic) NSArray *allMensen;
@property (strong, nonatomic) UHDMensa *selectedMensa;



@end


@implementation UHDMensaViewController

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UHDMensa *mensa = (UHDMensa *)self.fetchedResultsControllerDataSource.selectedItem;
    UHDDailyMenu *dailyMenu = [[mensa.menus sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES] ]] lastObject];
    
    UHDDailyMenuViewController *dailyMenuVC = (UHDDailyMenuViewController *) segue.destinationViewController;

    dailyMenuVC.dailyMenu = dailyMenu;
    
}

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource {
    if (!_fetchedResultsControllerDataSource) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];

        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
            managedObjectContext:self.managedObjectContext
              sectionNameKeyPath:nil
                    cacheName:nil];

        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, UHDMensa *item) {
            cell.textLabel.text = item.title;
        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"mensaCell" configureCellBlock:configureCellBlock];
        
    }
    return _fetchedResultsControllerDataSource;
}

- (NSArray *)allMensen
{
    if (!_allMensen) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
        _allMensen = [self.managedObjectContext executeFetchRequest:request error:NULL];
    }
    
    return _allMensen;
}


- (IBAction)showMensaSelection:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Wähle deine Mensa"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    NSArray *mensen = [self allMensen];
    for (UHDMensa *mensa in mensen) {
        [actionSheet addButtonWithTitle:mensa.title];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"schließen"];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.allMensen count] <= buttonIndex) return;
    
    self.selectedMensa = self.allMensen[buttonIndex];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UHDMensa *mensa = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate selectMense:mensa];
    [self dismissViewControllerAnimated:YES completion:nil];
}








@end
