//
//  UHDNewsDetailViewController.m
//  uni-hd
//
//  Created by Kevin Geier on 12.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsDetailViewController.h"
#import "UHDNewsItem.h"


@interface UHDNewsDetailViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *newsWebView;

@end

@implementation UHDNewsDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.newsItem.title;
    
    // Show URL in WebView
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.newsItem.url];
    [self.newsWebView loadRequest:requestObj];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
