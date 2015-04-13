//
//  UHDTalkDetailViewController.m
//  uni-hd
//
//  Created by Kevin Geier on 11.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDTalkDetailViewController.h"

#import <MessageUI/MessageUI.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

#import <UHDKit/UHDKit-Swift.h>

// Table View Cells
#import "UHDTalkDetailTitleAbstractCell.h"
#import "UHDTalkDetailSpaceTimeCell.h"
#import "UHDTalkDetailTitleCell.h"
#import "UHDTalkDetailSpeakerCell.h"
#import "UHDTalkDetailAbstractCell.h"
#import "UHDTalkDetailTimeCell.h"
#import "UHDTalkDetailLocationCell.h"
#import "UHDTalkDetailSourceCell.h"

#import "UHDNewsSource.h"

@interface UHDTalkDetailViewController () <EKEventEditViewDelegate, MFMailComposeViewControllerDelegate,  MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UIView *navigationItemContainerView;
@property (weak, nonatomic) IBOutlet UILabel *navigationItemTitleLabel;

@property (strong, nonatomic) EKEventStore *eventStore;

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

/*
- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];
	
	// force immediate layout of subviews
	[self.tableView layoutIfNeeded];
}
*/

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	
	// trigger height recalculation of table view
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
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
	
	// configure navigation bar
	self.navigationItemContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	self.navigationItemTitleLabel.text = self.talkItem.source.title;
	self.navigationItemTitleLabel.textColor = [UIColor whiteColor];
	
	[self.tableView reloadData];
	
	// force table view layout to prevent visible layout corrections after initial appearance of the VC
	[self.tableView layoutIfNeeded];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - User interaction

- (IBAction)addToCalendarButtonPressed:(id)sender {
	[self addToCalendar];
}

- (void)addToCalendar {
	
    // TODO: never reach up to the app delegate to get information! pass data down.
    EKEventStore *eventStore = self.eventStore;
    
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
	event.location = self.talkItem.formattedLocation;
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
    eventEditVC.eventStore = self.eventStore;
	eventEditVC.editViewDelegate = self;
	eventEditVC.event = event;
	
	[self presentViewController:eventEditVC animated:YES completion:nil];
	
}

- (IBAction)speakereButtonPressed:(id)sender {
	[self showSpeakerInformation];
}

- (void)showSpeakerInformation {

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
	[self showOnMap];
}

- (void)showOnMap {

	UIAlertController *alertController;
	
	if (self.talkItem.location) {
		alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
		
		UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ort auf der Campus-Karte anzeigen", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
				[self showLocation:self.talkItem.location animated:YES];
			}];
		[alertController addAction:action];
		
		UIAlertAction *abort = [UIAlertAction actionWithTitle:NSLocalizedString(@"Abbrechen", nil) style:UIAlertActionStyleCancel handler:nil];
		[alertController addAction:abort];
	}
	else {
		alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Dieser Veranstaltungsort kann auf der Campus-Karte nicht angezeigt werden.", nil) preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
		[alertController addAction:okAction];
	}
	
	[self presentViewController:alertController animated:YES completion:nil];
}

- (EKEventStore *)eventStore {
    if (!_eventStore) {
        self.eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}


# pragma mark - Table View Datasource

/*
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell;

    switch (indexPath.section) {
        case 0: {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"titleAbstract"];
            [(UHDTalkDetailTitleAbstractCell *)cell configureForItem:self.talkItem];
			break;
		}
        case 1: {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"spaceTime"];
            [(UHDTalkDetailSpaceTimeCell *)cell configureForItem:self.talkItem];
			break;
		}
        default:
            return nil;
    }
	
	return cell;
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSInteger rows = 2;
	
	switch (section) {
		case 0: {
			if (self.talkItem.speaker.name.length > 0) rows += 1;
			if (self.talkItem.abstract.length > 0) rows += 1;
			break;
		}
		case 1: {
			rows = 2;
			break;
		}
		default:
			rows = 0;
			break;
	}
	
	return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	 switch (section) {
        case 0:
            return NSLocalizedString(@"Titel und Inhalt", nil);
        case 1:
            return NSLocalizedString(@"Ort und Zeit der Veranstaltung", nil);
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell;
	
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0: {
				cell = [self.tableView dequeueReusableCellWithIdentifier:@"source"];
				[(UHDTalkDetailSourceCell *)cell configureForItem:self.talkItem];
				break;
			}
			case 1: {
				cell = [self.tableView dequeueReusableCellWithIdentifier:@"title"];
				[(UHDTalkDetailTitleCell *)cell configureForItem:self.talkItem];
				break;
			}
			case 2: {
				if (self.talkItem.speaker.name.length > 0) {
					cell = [self.tableView dequeueReusableCellWithIdentifier:@"speaker"];
					[(UHDTalkDetailSpeakerCell *)cell configureForItem:self.talkItem];
				}
				else {
					cell = [self.tableView dequeueReusableCellWithIdentifier:@"abstract"];
					[(UHDTalkDetailAbstractCell *)cell configureForItem:self.talkItem];
				}
				break;
			}
			case 3: {
				cell = [self.tableView dequeueReusableCellWithIdentifier:@"abstract"];
				[(UHDTalkDetailAbstractCell *)cell configureForItem:self.talkItem];
				break;
			}
			default:
				return nil;
		}
	}
	else if (indexPath.section == 1) {
		switch (indexPath.row) {
			case 0: {
				cell = [self.tableView dequeueReusableCellWithIdentifier:@"time"];
				[(UHDTalkDetailTimeCell *)cell configureForItem:self.talkItem];
				break;
			}
			case 1: {
				cell = [self.tableView dequeueReusableCellWithIdentifier:@"location"];
				[(UHDTalkDetailLocationCell *)cell configureForItem:self.talkItem];
				break;
			}
			default:
				return nil;
		}
	}
	else {
		return nil;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0 && indexPath.row == 2 && self.talkItem.speaker.name.length > 0) {
		[self showSpeakerInformation];
	}
	else if (indexPath.section == 1) {
		if (indexPath.row == 0) [self addToCalendar];
		else if (indexPath.row == 1) [self showOnMap];
	}
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
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
/*
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
}
*/


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
