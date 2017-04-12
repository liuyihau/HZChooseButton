//
//  FunctionMenuView.m
//  Pods
//
//  Created by LiuYihua on 2017/4/11.
//
//

#import "FunctionMenuView.h"
#import "ChooseButtonViewController.h"
#import "HZSingletonManager.h"
#import "MJExtension.h"

#import "CustomGridModel.h"


@implementation FunctionMenuView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}


/**
 创建视图并初始化数据源

 @param frame frame
 @param gridDateSource 全部数据源
 @param number 首页呈现个数
 @return 首页呈现数图
 */
- (id)initWithFrame:(CGRect)frame gridDateSource:(NSMutableArray *)gridDateSource number:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            [self createDataWithgridDateSource:gridDateSource number:number];
            
        });
        
    }
    return self;
}



/**
 初始化数据源

 @param gridDateSource 全部数据源
 @param number 首页呈现个数
 
 */
-(void)createDataWithgridDateSource:(NSMutableArray *)gridDateSource number:(int)number
{
    
    //所有应用数据
    NSMutableArray * arrayModel = [CustomGridModel mj_objectArrayWithKeyValuesArray:gridDateSource];
    
    [HZSingletonManager shareInstance].gridDateSource = arrayModel;
    
    
    //我的所有数据
    NSString *path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"showGridArray"];
    NSMutableArray * showGridArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!showGridArray || showGridArray.count == 0) {//第一次启动应用，未选择时数据，默认显示前7个应用数据
        
        showGridArray = [NSMutableArray arrayWithCapacity:10];
        
        for (int i = 0; i < number; i++) {
            
            [showGridArray addObject:arrayModel[i]];
            
        }
    }
    
    //我的应用数据
    [HZSingletonManager shareInstance].myGridArray = showGridArray;
    
    
}

@end
