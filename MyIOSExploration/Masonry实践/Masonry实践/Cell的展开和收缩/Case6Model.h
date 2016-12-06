//
//  Case6CellModel.h
//  Masonry实践
//
//  Created by fang wang on 16/12/6.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Case6Model : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;
@property (assign, nonatomic) CGFloat cellHeight;

@property (assign, nonatomic) BOOL expanded; // 是否已经展开
@end
