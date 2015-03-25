//
//  UHDConfigureMapViewController.m
//  uni-hd
//
//  Created by Andreas Schachner on 15.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDConfigureMapViewController.h"
#import <UHDKit/UHDKit-Swift.h>


@interface UHDConfigureMapViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeControl;
- (IBAction)mapTypeControlValueChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *showCampusOverlaySwitch;

@end


@implementation UHDConfigureMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureView) name:NSUserDefaultsDidChangeNotification object:nil];
}

- (void)configureView
{
    NSUInteger selectedSegmentIndex = 0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[UHDConstants userDefaultsKeyMapType]]) {
        switch ([(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:[UHDConstants userDefaultsKeyMapType]] unsignedIntegerValue]) {
            case MKMapTypeStandard:
                selectedSegmentIndex = 0;
                break;
            case MKMapTypeHybrid:
                selectedSegmentIndex = 1;
                break;
            case MKMapTypeSatellite:
                selectedSegmentIndex = 2;
                break;
            default:
                selectedSegmentIndex = -1;
                break;
        }
    } else {
        selectedSegmentIndex = -1;
    }
    self.mapTypeControl.selectedSegmentIndex = selectedSegmentIndex;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[UHDConstants userDefaultsKeyShowCampusOverlay]]) {
        self.showCampusOverlaySwitch.on = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:[UHDConstants userDefaultsKeyShowCampusOverlay]] boolValue];
    } else {
        self.showCampusOverlaySwitch.on = YES;
    }
}


#pragma mark - User Interaction

- (IBAction)mapTypeControlValueChanged:(id)sender
{
    MKMapType selectedMapType = MKMapTypeStandard;
    switch (self.mapTypeControl.selectedSegmentIndex) {
        case 0:
            selectedMapType = MKMapTypeStandard;
            break;
        case 1:
            selectedMapType = MKMapTypeHybrid;
            break;
        case 2:
            selectedMapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@( selectedMapType ) forKey:[UHDConstants userDefaultsKeyMapType]];
}

- (IBAction)showCampusOverlaySwitchValueChanged:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@( self.showCampusOverlaySwitch.isOn ) forKey:[UHDConstants userDefaultsKeyShowCampusOverlay]];
}

@end
