//
//  ViewController.m
//  多线程实战
//
//  Created by wangdongyang on 16/9/9.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ViewController.h"
#import "itemModel.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray* dataArr;
@property (nonatomic, strong) NSMutableDictionary *imageDict;
@property (nonatomic, strong) NSMutableDictionary *operationDict;
@property (nonatomic, strong) NSOperationQueue* queue;
@end

static NSString* identifier = @"cell";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    itemModel* model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.download;

    if ([self.imageDict objectForKey:model.icon]) {
        cell.imageView.image = [self.imageDict objectForKey:model.icon];
        NSLog(@"%zd处使用了内存缓存中的图片", indexPath.row);
    }else{
        
        NSString* caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString* fileName = [model.icon lastPathComponent];
        NSString* fullPath = [caches stringByAppendingPathComponent:fileName];
        NSData* imageD = [NSData dataWithContentsOfFile:fullPath];
        
        if (imageD) {
            UIImage* image = [UIImage imageWithData:imageD];
            [self.imageDict setObject:image forKey:model.icon];
            cell.imageView.image = image;
            NSLog(@"%zd处使用了磁盘缓存中的图片", indexPath.row);
//            NSLog(@"%@", fullPath);
        }else{
            // 先看看operation操作缓存是否存在，即是否真正下载
            NSBlockOperation* blockOp = [self.operationDict objectForKey:model.icon];
            if (blockOp) {
                
            }else{
                // 使用占位图片
                cell.imageView.image = [UIImage imageNamed:@"apple-touch-icon"];
                
                blockOp = [NSBlockOperation blockOperationWithBlock:^{
                    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.icon]];
                    UIImage* image = [UIImage imageWithData:data];
                    
                    if (!image) {
                        [self.operationDict removeObjectForKey:model.icon];
                        return;
                    }
                    [self.imageDict setObject:image forKey:model.icon];
                    [data writeToFile:fullPath atomically:YES];
                    
                    NSLog(@"-------下载-------");
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        cell.imageView.image = image;
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    
                    //移除图片的下载操作
                    [self.operationDict removeObjectForKey:model.icon];
                }];
                // 缓存operation操作
                [self.operationDict setObject:blockOp forKey:model.icon];
                [self.queue addOperation:blockOp];
            }
        }
    }
    return cell;
}

- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 5;
    }
    return _queue;
}

- (NSArray *)dataArr
{
    if (!_dataArr) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"apps.plist" ofType:nil];
        NSArray* arr = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray* dataArray = [NSMutableArray array];
        for (NSDictionary* dict in arr) {
            [dataArray addObject:[itemModel itemWithDic:dict]];
        }
        _dataArr = dataArray;
    }
    return _dataArr;
}

// 简单的缓存
- (NSMutableDictionary *)imageDict
{
    if (!_imageDict) {
        _imageDict = [NSMutableDictionary dictionary];
    }
    return _imageDict;
}

// 操作的缓存
- (NSMutableDictionary *)operationDict
{
    if (!_operationDict) {
        _operationDict = [NSMutableDictionary dictionary];
    }
    return _operationDict;
}

// 内存警告处理
-(void)didReceiveMemoryWarning
{
    [self.imageDict removeAllObjects];
    //取消队列中所有的操作
    [self.queue cancelAllOperations];
}

@end
