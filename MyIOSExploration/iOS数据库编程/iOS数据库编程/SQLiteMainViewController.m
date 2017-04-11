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
 
 https://knightsj.github.io/2017/01/13/%E9%AB%98%E5%BA%A6%E5%B0%81%E8%A3%85FMDB%E6%A1%86%E6%9E%B6%EF%BC%9A%E5%90%84%E7%94%A8%E4%B8%80%E5%8F%A5%E4%BB%A3%E7%A0%81%E6%9B%B4%E6%96%B0%EF%BC%88%E6%B7%BB%E5%8A%A0&%E4%BF%AE%E6%94%B9%EF%BC%89%EF%BC%8C%E6%9F%A5%E8%AF%A2%EF%BC%8C%E5%88%A0%E9%99%A4%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF/
 */
