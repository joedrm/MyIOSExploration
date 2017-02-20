//
//  AutoHeightViewController.m
//  UITableView性能优化
//
//  Created by fang wang on 17/2/3.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "AutoHeightViewController.h"
#import "MyTableViewCell.h"

@interface AutoHeightViewController ()

@end

@implementation AutoHeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UINib *nib = [UINib nibWithNibName:@"MyTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MyTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell" forIndexPath:indexPath];
    
    return cell;
}

@end
