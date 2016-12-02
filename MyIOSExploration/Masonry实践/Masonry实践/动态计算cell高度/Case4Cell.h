//
//  Case4Cell.h
//  Masonry实践
//
//  Created by fang wang on 16/12/2.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Case4Model.h"

static NSString* identifier = @"cell";

@interface Case4Cell : UITableViewCell

- (void)setupData:(Case4Model *)model;
@end
