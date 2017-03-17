//
//  SQLiteMainViewController.m
//  SQLite入门到实践
//
//  Created by fang wang on 17/3/7.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import "SQLiteMainViewController.h"

@interface SQLiteMainViewController ()

@end

@implementation SQLiteMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"iOS数据库编程";
    self.titleArr = @[
                      
                      ];
    
    self.vcArr = @[
                   
                   ];
}



@end

/*
 参考资料：
 
 https://github.com/netyouli/WHC_ModelSqliteKit  采用runtime和Sqlite完美结合打造的强大数据库操作引擎开源库
 
 https://github.com/li6185377/LKDBHelper-SQLite-ORM 全自动的插入,查询,更新,删除 
 
 http://www.jianshu.com/p/4bc34f982fee  iOS - 关于移动端SQLite，你想知道的都有
 
 https://github.com/gaojunquan/JQFMDB FMDB的封装,操作简单,线程安全,扩展性强,直接操作model或dictionary
 
 https://github.com/huangzhibiao/BGFMDB  FMDB 的封装
 */
