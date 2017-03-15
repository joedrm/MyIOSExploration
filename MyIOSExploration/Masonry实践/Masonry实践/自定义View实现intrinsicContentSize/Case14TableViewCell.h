//
//  Case14TableViewCell.h
//  Masonry实践
//
//  Created by fang wang on 17/3/15.
//  Copyright © 2017年 com.LBE.Photo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Case14StairView.h"

static NSString *kCase14TableViewCellIdentifier = @"Case14TableViewCell";
@interface Case14TableViewCell : UITableViewCell

@property (nonatomic, strong) Case14StairView *stairView;
@end
