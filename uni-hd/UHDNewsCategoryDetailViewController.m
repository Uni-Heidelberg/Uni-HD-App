//
//  UHDNewsCategoryDetailViewController.m
//  uni-hd
//
//  Created by Andreas Schachner on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsCategoryDetailViewController.h"
#import "UHDNewsSource.h"

@interface UHDNewsCategoryDetailViewController ()

@end

@implementation UHDNewsCategoryDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.newsSource.title;
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do something.
}

@end
