//
//  ProgressViewController.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ProgressViewController.h"
#import "ProgressView.h"

@interface ProgressViewController ()

@property (weak, nonatomic) IBOutlet ProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressTitle;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)valueChanged:(UISlider *)sender {
    
    NSLog(@"value = %.2f", sender.value);
    self.progressTitle.text = [NSString stringWithFormat:@"%.2f%%", sender.value*100];
    self.progressView.progress = sender.value;
    
}

@end
