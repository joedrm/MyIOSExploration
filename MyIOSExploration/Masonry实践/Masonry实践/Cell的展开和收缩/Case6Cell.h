//
//  Case6Cell.h
//  Masonry实践
//
//  Created by fang wang on 16/12/6.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Case6Model.h"

static NSString* Case6CellIidentifier = @"cell";
@class Case8DataEntity;
@class Case6Cell;

@protocol Case6CellDelegate <NSObject>
- (void)case8Cell:(Case6Cell *)cell switchExpandedStateWithIndexPath:(NSIndexPath *)index;
@end

@interface Case6Cell : UITableViewCell
@property (weak, nonatomic) id <Case6CellDelegate> delegate;

- (void)setEntity:(Case6Model *)entity indexPath:(NSIndexPath *)indexPath;
@end
