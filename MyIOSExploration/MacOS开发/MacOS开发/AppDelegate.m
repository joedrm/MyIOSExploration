//
//  AppDelegate.m
//  MacOS开发
//
//  Created by fang wang on 17/3/8.
//  Copyright © 2017年 osDev. All rights reserved.
//

#import "AppDelegate.h"
#import "OSMainViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    OSMainViewController* main = [[OSMainViewController alloc] init];
    
    [self.window makeKeyAndOrderFront:main];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
