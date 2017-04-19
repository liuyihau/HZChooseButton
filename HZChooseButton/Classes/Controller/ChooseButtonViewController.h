//
//  ChooseButtonViewController.h
//  Pods
//
//  Created by LiuYihua on 2017/4/7.
//
//

#import <UIKit/UIKit.h>

@class CustomGrid;

typedef void (^func_loadGridListViewDataSoruce)(NSMutableArray * dateSource);
typedef void (^func_listViweClick)(CustomGrid *gridItem);

@interface ChooseButtonViewController : UIViewController


/**
 刷新首页数据源
 */
@property (nonatomic, copy) func_loadGridListViewDataSoruce  func_loadGridListViewDataSoruce;
@property (nonatomic, copy) func_listViweClick func_listViweClick;

@property (nonatomic, assign) BOOL fromEditBtn;

@end