//
//  HZAppDelegate.m
//  HZChooseButton
//
//  Created by liuyihua2015@sina.com on 04/07/2017.
//  Copyright (c) 2017 liuyihua2015@sina.com. All rights reserved.
//

#import "HZAppDelegate.h"



#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@implementation HZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(70, 154, 233, 1.0)];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          nil]];
    

    return YES;
}


@end
