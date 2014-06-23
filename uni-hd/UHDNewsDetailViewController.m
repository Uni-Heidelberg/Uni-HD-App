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
@property (nonatomic) UITapGestureRecognizer *tap;
@property BOOL scalesPageToFit;
@property (nonatomic) NSArray *arrayOfActivityItems;
@property (nonatomic) UIActivityViewController *activityVC;
@property(nonatomic, assign, getter=isTranslucent) BOOL translucent;


-(IBAction)UIButton:(id)shareButton;


@end

@implementation UHDNewsDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.newsItem.title;
    
    // Show URL in WebView
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.newsItem.url];
    [self.newsWebView loadRequest:requestObj];
    _newsWebView.scalesPageToFit = YES;
   
    
}


-(IBAction)UIButton:(id)shareButton{
    

    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:@[self.newsItem.title,   self.newsItem.url]applicationActivities:nil];
    
    [self.navigationController presentViewController:activityVC animated:YES completion:nil];
    
    
}



- (void) hideShowNavigation
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden];
}



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = YES;
    
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShowNavigation)] initWithTarget:self.newsWebView action: Nil];
    tap.numberOfTapsRequired = 1;
    [self.newsWebView addGestureRecognizer:tap];
    


}

@end
