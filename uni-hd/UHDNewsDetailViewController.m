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

@property (strong, nonatomic) IBOutlet UIView *newsContentView;

@end

@implementation UHDNewsDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.newsItem.title;
    
    //instantiate the web view
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.newsContentView.frame];

    //make the background transparent
    [webView setBackgroundColor:[UIColor clearColor]];

    //pass the string to the webview
    [webView loadHTMLString:[self.newsItem.content description] baseURL:nil];

    //add it to the subview
    [self.newsContentView addSubview:webView];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do something.
}

@end
