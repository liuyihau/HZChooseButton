//
//  ChooseButtonViewController.h
//  Pods
//
//  Created by LiuYihua on 2017/4/7.
//
//

#import <UIKit/UIKit.h>

@class CustomGrid;

typedef void (^loadGridListViewDataSoruce)(NSMutableArray * dateSource);

@interface ChooseButtonViewController : UIViewController

//我的应用
@property (nonatomic, strong) NSMutableArray * gridListArray;
//我的应用 数据源
@property (nonatomic, strong) NSMutableArray * showGridArray;

//全部应用
@property (nonatomic, strong) NSMutableArray * allGridItemArray;
//全部应用 数据源
@property (nonatomic, strong) NSMutableArray * allGridArray;

/**
 刷新首页数据源
 */
@property (nonatomic, strong) loadGridListViewDataSoruce  loadGridListViewDataSoruce;


#pragma mark -
- (void)gridItemDidClicked:(CustomGrid *)gridItem;

@end
