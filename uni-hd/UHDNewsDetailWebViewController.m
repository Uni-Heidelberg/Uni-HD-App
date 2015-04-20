//
//  UHDNewsDetailViewController.m
//  uni-hd
//
//  Created by Kevin Geier on 12.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsDetailWebViewController.h"
#import "UHDNewsItem.h"


@interface UHDNewsDetailWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *newsWebView;

- (IBAction)shareButtonPressed:(id)sender;

@end

@implementation UHDNewsDetailWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = self.newsItem.title;
    
    // Show URL in WebView
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.newsItem.url];
    [self.newsWebView loadRequest:requestObj];
    _newsWebView.scalesPageToFit = YES;
    
}

- (IBAction)shareButtonPressed:(id)sender
{
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:@[self.newsItem.title, self.newsItem.url] applicationActivities:nil];
    [self.navigationController presentViewController:activityVC animated:YES completion:nil];
}

@end
