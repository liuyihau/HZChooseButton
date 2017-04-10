//
//  HZAppDelegate.m
//  HZChooseButton
//
//  Created by liuyihua2015@sina.com on 04/07/2017.
//  Copyright (c) 2017 liuyihua2015@sina.com. All rights reserved.
//

#import "HZAppDelegate.h"
#import "ChooseButtonViewController.h"
#import "HZSingletonManager.h"
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@implementation HZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(70, 154, 233, 1.0)];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          nil]];
    
    
    [self createData];
    

    return YES;
}

-(void)createData
{
    // 如果数组有改变
    NSArray * titleArray = [[NSArray alloc]init];
    NSArray * imageArray = [[NSArray alloc]init];
    NSArray * idArray = [[NSArray alloc]init];
    titleArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"title"];
    imageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
    idArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"gridID"];
    NSLog(@"array = %@",titleArray);
    
    NSArray * moretitleArray = [[NSArray alloc]init];
    NSArray * moreimageArray = [[NSArray alloc]init];
    NSArray * moreidArray = [[NSArray alloc]init];
    moretitleArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"moretitle"];
    moreimageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"moreimage"];
    moreidArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"moregridID"];
    
    // Home按钮数组 体验账号
    [HZSingletonManager shareInstance].showGridArray = [[NSMutableArray alloc]initWithCapacity:12];
    [HZSingletonManager shareInstance].showImageGridArray = [[NSMutableArray alloc]initWithCapacity:12];
    
    [HZSingletonManager shareInstance].showGridArray = [NSMutableArray arrayWithObjects:@"1收银台",@"2结算",@"3分享", @"4T+0", @"5中心",@"6D+1", @"7商店",@"8P2P", @"9开通", @"10充值", @"11转账", @"12扫码", @"13记录" , @"14快捷支付", @"15明细", @"16收款", nil];
    
    [HZSingletonManager shareInstance].showImageGridArray =
    [NSMutableArray arrayWithObjects:
     @"more_icon_Transaction_flow",@"more_icon_cancle_deal", @"more_icon_Search",
     @"more_icon_t0",@"more_icon_shouyin" ,@"more_icon_d1",
     @"more_icon_Settlement",@"more_icon_Mall", @"more_icon_gift",
     @"more_icon_licai",@"more_icon_-transfer",@"more_icon_Recharge" ,
     @"more_icon_Transfer-" , @"more_icon_Credit-card-",@"more_icon_Manager",@"work-order", nil];
    
    [HZSingletonManager shareInstance].showGridIDArray =
    [NSMutableArray arrayWithObjects:
     @"1000",@"1001", @"1002",
     @"1003",@"1004",@"1005" ,@"1006",
     @"1007",@"1008", @"1009",
     @"1010",@"1011",@"1012" ,
     @"1013" , @"1014",@"1015", nil];
    
    // 对比数组
    NSMutableString * defaString = [[NSMutableString alloc]init];
    NSMutableString * localString = [[NSMutableString alloc]init];
    
    // 默认
    for (int i = 0; i< [HZSingletonManager shareInstance].showGridArray.count; i++) {
        [defaString appendString:[HZSingletonManager shareInstance].showGridArray[i]];
        NSLog(@"defaString = %@",defaString);
    }
    // 本地
    for (int i = 0; i< titleArray.count; i++) {
        [localString appendString:titleArray[i]];
        NSLog(@"localString = %@",localString);
    }
    
    // 如果本地数组有改变
    if (![localString isEqualToString:defaString] && localString.length>2) {
        
        //        if (titleArray.count > 8) {//最外面的首页 默认只取前7个
        //
        //            [HZSingletonManager shareInstance].showGridArray = [[NSMutableArray alloc]initWithArray:[titleArray subarrayWithRange:NSMakeRange(0, 8)]];
        //            [HZSingletonManager shareInstance].showImageGridArray = [[NSMutableArray alloc]initWithArray:[imageArray subarrayWithRange:NSMakeRange(0, 8)]];
        //            [HZSingletonManager shareInstance].showGridIDArray = [[NSMutableArray alloc]initWithArray:[idArray subarrayWithRange:NSMakeRange(0, 8)]];
        //
        //        }else{
        
        [HZSingletonManager shareInstance].showGridArray = [[NSMutableArray alloc]initWithArray:titleArray];
        [HZSingletonManager shareInstance].showImageGridArray = [[NSMutableArray alloc]initWithArray:imageArray];
        [HZSingletonManager shareInstance].showGridIDArray = [[NSMutableArray alloc]initWithArray:idArray];
        
        
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
