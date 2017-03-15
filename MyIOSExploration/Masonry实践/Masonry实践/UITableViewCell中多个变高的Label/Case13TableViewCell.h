//
//  Case13TableViewCell.h
//  Masonry实践
//
//  Created by fang wang on 17/3/15.
//  Copyright © 2017年 com.LBE.Photo. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *kCase13TableViewCellIdentifier = @"Case13TableViewCell";

@interface Case13TableViewCell : UITableViewCell

- (void)configWithTexts:(NSArray <NSString *> *)cellTexts;
@end
