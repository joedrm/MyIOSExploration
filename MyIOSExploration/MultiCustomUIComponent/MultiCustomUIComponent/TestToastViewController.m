//
//  TestToastViewController.m
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "TestToastViewController.h"

@interface TestToastViewController ()

@property(nonatomic, strong) NSArray<NSString *> *dataSource;
@end

@implementation TestToastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@"Loading",
                        @"Loading With Text",
                        @"Tips For Succeed",
                        @"Tips For Error",
                        @"Tips For Info",
                        @"Custom TintColor",
                        @"Custom BackgroundView Style",
                        @"Custom Animator",
                        @"Custom Content View"];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

@end
