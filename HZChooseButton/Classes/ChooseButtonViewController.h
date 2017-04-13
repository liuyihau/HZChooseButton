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



/**
 刷新首页数据源
 */
@property (nonatomic, strong) loadGridListViewDataSoruce  loadGridListViewDataSoruce;


#pragma mark -
- (void)gridItemDidClicked:(CustomGrid *)gridItem;

@end
