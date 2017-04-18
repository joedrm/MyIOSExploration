//
//  CenterTwoViewsVC.m
//  AutoLayoutPractice
//
//  Created by fang wang on 17/4/18.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CenterTwoViewsVC.h"

@interface CenterTwoViewsVC ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation CenterTwoViewsVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self makeUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeText)];
    [self.view addGestureRecognizer:tap];
}

- (void)makeUI
{
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppleLogo"]];
    [self.view addSubview:self.imageView];
    
    self.label = [[UILabel alloc] init];
    self.label.text = @"WATCH";
    self.label.font = [UIFont boldSystemFontOfSize:45.0];
    [self.view addSubview:self.label];
    
    UIView *helperView = [[UIView alloc] init];
    helperView.backgroundColor = [UIColor redColor];
    [self.view addSubview:helperView];
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    helperView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = @{@"imageView":self.imageView,
                                      @"label":self.label};
    
    NSArray *constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[imageView]-[label]-(>=0)-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:viewsDictionary];
    
    
    NSLayoutConstraint *constraint1 =[NSLayoutConstraint constraintWithItem:self.imageView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1
                                                                   constant:100];
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.label
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.imageView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1
                                                                    constant:5];
    
    // nix 的妙想：利用 helperView 将 iconImage 和 label “合起来” X 居中
    NSLayoutConstraint *constraint3 =[NSLayoutConstraint constraintWithItem:helperView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.imageView
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1
                                                                   constant:0];
    
    NSLayoutConstraint *constraint4 =[NSLayoutConstraint constraintWithItem:helperView
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.label
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1
                                                                   constant:0];
    
    NSLayoutConstraint *constraint5 =[NSLayoutConstraint constraintWithItem:helperView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1
                                                                   constant:0];
    
    NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:helperView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:1
                                                                   constant:30];
    NSLayoutConstraint *constraint7 = [NSLayoutConstraint constraintWithItem:helperView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1
                                                                    constant:200];
    [helperView addConstraint:constraint6];
    [self.view addConstraint:constraint7];
    
    [self.view addConstraints:constraintH];
    
    [self.view addConstraint:constraint1];
    [self.view addConstraint:constraint2];
    
    [self.view addConstraint:constraint3];
    [self.view addConstraint:constraint4];
    [self.view addConstraint:constraint5];
}

- (void)changeText
{
    static int i = 0;
    
    NSString *nixString = @" I'm WDY.";
    
    if (i < nixString.length) {
        NSMutableString *string = [NSMutableString stringWithString:self.label.text];
        [string appendString:[nixString substringWithRange:NSMakeRange(i, 1)]];
        
        i += 1;
        
        self.label.text = string;
        
        self.label.backgroundColor = [UIColor lightGrayColor];
    }
}

@end
