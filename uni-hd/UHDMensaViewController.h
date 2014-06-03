//
//  UHDMensaViewController.h
//  uni-hd
//
//  Created by Felix on 07.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "UHDDailyMenuViewController.h"


@protocol UHDMensaViewControllerDelegate <NSObject>
-(void) done:(UHDMensa *)mensa;
@end

@interface UHDMensaViewController : UITableViewController <UIActionSheetDelegate>{
    id delegate;
}

@property (nonatomic, assign) id <UHDMensaViewControllerDelegate> delegate;
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (IBAction)buttonPressed:(id)sender;

@end
