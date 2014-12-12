//
//  UHDTalkDetailViewController.m
//  uni-hd
//
//  Created by Kevin Geier on 11.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <EventKit/EventKit.h>

#import "UHDTalkDetailViewController.h"
#import "UHDTalkDetailTitleAbstractCell.h"

#import "UHDNewsSource.h"

@interface UHDTalkDetailViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *navigationItemTitleLabel;

@end


@implementation UHDTalkDetailViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 200;
	
	[self configureView];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
	});
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollViewDidScroll:self.tableView];
}


- (void)configureView {

	// configure header view
	if (self.talkItem.image == nil) {
		[self.tableView.tableHeaderView removeFromSuperview];
		self.tableView.tableHeaderView = nil;
	}
	else {
		self.headerImageView.image	= self.talkItem.image;
		//self.headerImageView.image = [UIImage imageNamed:@"talkSampleImage"];
		UIView *headerView = self.tableView.tableHeaderView;
		CGRect frame = headerView.frame;
		frame.size.height = self.tableView.bounds.size.height / 3;
		headerView.frame = frame;
		self.tableView.tableHeaderView = headerView;
	}
	
	self.navigationItemTitleLabel.text = self.talkItem.source.title;
	
	[self.tableView reloadData];

}


# pragma mark - User interaction


- (IBAction)addToCalendarButtonPressed:(id)sender {

	EKEventStore *eventStore = [[EKEventStore alloc] init];
	
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (error == nil) {
        }
        else{
        }
    }];

	EKEvent *event = [EKEvent eventWithEventStore:eventStore];
	
	event.title = self.talkItem.title;
	event.location = self.talkItem.location;
	event.startDate = self.talkItem.date;
	event.endDate = self.talkItem.date;
	event.allDay = false;
	event.notes = self.talkItem.abstract;
	event.calendar = [eventStore defaultCalendarForNewEvents];
	
	[eventStore saveEvent:event span:EKSpanFutureEvents commit:YES error:nil];

	// TODO: present succession message and make sure that items are not doubled...

}


- (IBAction)speakerButtonPressed:(id)sender {

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	
	UIAlertAction *visitWebsite = [UIAlertAction actionWithTitle:NSLocalizedString(@"Website anzeigen", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[[UIApplication sharedApplication] openURL:self.talkItem.url];
	}];
	[alertController addAction:visitWebsite];
	
	//self.talkItem.speaker.email = @"Kevin.Geier91@Gmail.com";
	
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


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
	
	// Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
}


# pragma mark - Table View Data Source

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


# pragma mark - Scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGRect imageFrame = self.headerImageView.frame;
    imageFrame.origin.y = offset;
    imageFrame.size.height = - offset + self.tableView.tableHeaderView.frame.size.height;
    self.headerImageView.frame = imageFrame;
}


@end
