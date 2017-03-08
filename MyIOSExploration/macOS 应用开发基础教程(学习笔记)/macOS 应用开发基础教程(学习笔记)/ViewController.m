//
//  ViewController.m
//  macOS 应用开发基础教程(学习笔记)
//
//  Created by fang wang on 17/3/8.
//  Copyright © 2017年 osDev. All rights reserved.
//

/*
 http://macdev.io/index.html  
 https://github.com/iCHAIT/awesome-macOS#e-book-utilities
 */

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSView* view = [[NSView alloc] init];
    view.frame = CGRectMake(100, 200, 50, 50);
    view.layer.backgroundColor = [NSColor redColor].CGColor;
    [self.view addSubview:view];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
