//
//  UHDTalkDetailViewController.m
//  uni-hd
//
//  Created by Kevin Geier on 11.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDAppDelegate.h"

#import <MessageUI/MessageUI.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

#import "UHDTalkDetailViewController.h"
#import "UHDTalkDetailTitleAbstractCell.h"

#import "UHDNewsSource.h"

@interface UHDTalkDetailViewController () <EKEventEditViewDelegate, MFMailComposeViewControllerDelegate,  MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *navigationItemTitleLabel;

@end


@implementation UHDTalkDetailViewController

- (void)setTalkItem:(UHDTalkItem *)talkItem {
    if (_talkItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:_talkItem.managedObjectContext];
    }
    _talkItem = talkItem;
    if (talkItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextObjectsDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:talkItem.managedObjectContext];
    }
    [self configureView];
}

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	[self configureView];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    // TOOD: what is this for?
	dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
	});
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.tableView adjustFrameForParallaxedHeaderView:self.headerImageView];
}

- (void)configureView
{
	// configure header view
    self.headerImageView.image = self.talkItem.image;
	if (self.headerImageView.image == nil) {
		self.tableView.tableHeaderView = nil;
	} else {
		self.tableView.tableHeaderView = self.headerView;
	}
	
	self.navigationItemTitleLabel.text = self.talkItem.source.title;
	
	[self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - User interaction

- (IBAction)addToCalendarButtonPressed:(id)sender {
	
	EKEventStore *eventStore = [(UHDAppDelegate *)[[UIApplication sharedApplication] delegate] eventStore];

	EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
	BOOL needsToRequestAccessToEventStore = (authorizationStatus == EKAuthorizationStatusNotDetermined);

    if (needsToRequestAccessToEventStore) {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted) {
                // Access granted
                [self.logger log:@"Access granted for entity type event" forLevel:VILogLevelInfo];
            }
            else {
                // Denied
                [self.logger log:@"Access denied for entity type event" forLevel:VILogLevelInfo];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Der Zugriff auf den Kalender wurde verweigert. Die Veranstaltung kann nicht in den Kalender eingetragen werden. Sie können die Zugriffsrechte in den Einstellungen anpassen.", nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }
        }];
    }
    else {
        BOOL granted = (authorizationStatus == EKAuthorizationStatusAuthorized);
        if (granted) {
            // Access granted
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Der Zugriff auf den Kalender wurde verweigert. Die Veranstaltung kann nicht in den Kalender eingetragen werden. Sie können die Zugriffsrechte in den Einstellungen anpassen.", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *hour = [[NSDateComponents alloc] init];
    hour.hour = 1;
    NSDate *endDate = [calendar dateByAddingComponents:hour toDate:self.talkItem.date options:0];
    
    // TODO: correct duration of the event
	
	EKEvent *event = [EKEvent eventWithEventStore:eventStore];
	
	event.title = self.talkItem.title;
	event.location = self.talkItem.location;
	event.startDate = self.talkItem.date;
	event.endDate = endDate;
	event.allDay = false;
	event.notes = self.talkItem.abstract;
	event.URL = self.talkItem.url;
	
	// TODO: find proper way of identifying events that have alreday been added using both the calendar and event identifiers
	
	NSPredicate *query = [eventStore predicateForEventsWithStartDate:self.talkItem.date endDate:endDate calendars:nil];
	
	NSArray *similarEvents = [eventStore eventsMatchingPredicate:query];
	
	EKEvent *calendarEvent = nil;
	
	for (EKEvent *ev in similarEvents) {
		if ([ev.title isEqualToString:self.talkItem.title]) {
			calendarEvent = ev;
		}
	}
	
	if (calendarEvent != nil) {
		UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Die Veranstaltung wurde bereits in den Kalender eingetragen. Kalendereintrag bearbeiten?", nil) preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *editAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Bearbeiten", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[self presentEventEditViewControllerForEvent:calendarEvent];
		}];
		UIAlertAction *abortAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Abbrechen", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
			return;
		}];
		[alertCtrl addAction:abortAction];
		[alertCtrl addAction:editAction];
		[self presentViewController:alertCtrl animated:YES completion:nil];
	}
	else {
		[self presentEventEditViewControllerForEvent:event];
	}
}

- (void)presentEventEditViewControllerForEvent:(EKEvent *)event {
	
	EKEventEditViewController *eventEditVC = [[EKEventEditViewController alloc] init];
	eventEditVC.eventStore = [(UHDAppDelegate *)[[UIApplication sharedApplication] delegate] eventStore];
	eventEditVC.editViewDelegate = self;
	eventEditVC.event = event;
	
	[self presentViewController:eventEditVC animated:YES completion:nil];
	
}

- (IBAction)speakereButtonPressed:(id)sender {

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.talkItem.speaker.name message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	
	UIAlertAction *visitWebsite = [UIAlertAction actionWithTitle:NSLocalizedString(@"Website anzeigen", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[[UIApplication sharedApplication] openURL:self.talkItem.speaker.url];
	}];
	[alertController addAction:visitWebsite];
	
	//self.talkItem.speaker.email = @"ab@c.de";
	
	if ([self.talkItem.speaker.email length] > 0) {
		UIAlertAction *email = [UIAlertAction actionWithTitle:NSLocalizedString(@"E-Mail schreiben", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
			mailVC.mailComposeDelegate = self;
			[mailVC setToRecipients:@[ self.talkItem.speaker.email ]];
			[self presentViewController:mailVC animated:YES completion:nil];
		}];
		[alertController addAction:email];
	}
	
	UIAlertAction *abort = [UIAlertAction actionWithTitle:NSLocalizedString(@"Abbrechen", nil) style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:abort];
	
	[self presentViewController:alertController animated:YES completion:nil];

}

- (IBAction)showOnMapButtonPressed:(id)sender {

	// TODO: show location of the event in maps module

}


# pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return nil;
        case 1:
            return NSLocalizedString(@"Ort und Zeit der Veranstaltung", nil);
        default:
            return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UHDTalkDetailTitleAbstractCell *cell;
    
    switch (indexPath.section) {
        case 0:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"titleAbstract"];
            break;
        case 1:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"spaceTime"];
            break;
        default:
            cell = nil;
            break;
    }
    
    [cell configureForItem:self.talkItem];
    
    return cell;	
}


# pragma mark - Mail Compose View Controller Delegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
			[self.logger log:@"Mail cancelled" forLevel:VILogLevelInfo];
            break;
        case MFMailComposeResultSaved:
			[self.logger log:@"Mail saved" forLevel:VILogLevelInfo];
            break;
        case MFMailComposeResultSent:
			[self.logger log:@"Mail sent" forLevel:VILogLevelInfo];
            break;
        case MFMailComposeResultFailed:
			[self.logger log:@"Mail sent" error:error];
            break;
        default:
            break;
    }
	
	// Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
}


# pragma mark - Event Edit View Delegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {

	switch (action) {
		case EKEventEditViewActionCanceled:
			[self.logger log:@"Event editing cancelled" forLevel:VILogLevelInfo];
			break;
		case EKEventEditViewActionDeleted:
			[self.logger log:@"Event deleted" forLevel:VILogLevelInfo];
			break;
		case EKEventEditViewActionSaved:
			{
				[self.logger log:@"Event saved" forLevel:VILogLevelInfo];
				
				[self dismissViewControllerAnimated:YES completion:^(void) {
					UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Die Veranstaltung wurde erfolgreich in den Kalender eingetragen.", nil) preferredStyle:UIAlertControllerStyleAlert];
					UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
					[alertController addAction:okAction];
					[self presentViewController:alertController animated:YES completion:nil];
				}];
			}
			return;
		default:
			break;
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView adjustFrameForParallaxedHeaderView:self.headerImageView];
}


#pragma mark - Managed Object Context Notifications

- (void)managedObjectContextObjectsDidChange:(NSNotification *)notification
{
    if (self.talkItem) {
        NSSet *updatedObjects = notification.userInfo[NSUpdatedObjectsKey];
        if ([updatedObjects containsObject:self.talkItem]) {
            [self configureView];
        }
    }
}



@end
