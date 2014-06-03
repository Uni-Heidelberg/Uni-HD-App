//
//  UHDMainMensaViewController.h
//  uni-hd
//
//  Created by Felix on 03.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDMensa.h"
#import "UHDMensaViewController.h"

@interface UHDMainMensaViewController : UIViewController <UHDMensaViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *DailyMenuViewContainer;
@property (weak, nonatomic) IBOutlet UIView *MensaViewContainer;
@property (strong, nonatomic) UHDMensa *mensa;

- (IBAction)mensaButtonPressed:(id)sender;
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
