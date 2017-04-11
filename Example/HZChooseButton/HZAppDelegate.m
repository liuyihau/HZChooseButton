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
#import "MJExtension.h"

#import "CustomGridModel.h"


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
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MoveTag" ofType:@"plist"];
    NSMutableArray * arrayM = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    NSMutableArray * arrayModel = [CustomGridModel mj_objectArrayWithKeyValuesArray:arrayM];
    //所有应用数据
    [HZSingletonManager shareInstance].gridDateSource = arrayModel;


    //反归档
    NSString *path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"showGridArray"];
    NSMutableArray * showGridArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!showGridArray || showGridArray.count == 0) {//第一次启动应用，未选择时数据，默认显示前7个应用数据
        
        showGridArray = [NSMutableArray arrayWithCapacity:10];
        
        for (int i = 0; i < 7; i++) {
           
            [showGridArray addObject:arrayModel[i]];
            
        }
        
    }
    
    //我的应用数据
    [HZSingletonManager shareInstance].myGridArray = showGridArray;
    
    
}

@end
