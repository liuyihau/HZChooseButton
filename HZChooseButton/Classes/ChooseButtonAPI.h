//
//  ChooseButtonAPI.h
//  Pods
//
//  Created by LiuYihua on 2017/4/28.
//
//

#import <Foundation/Foundation.h>

#import "ChooseButtonViewController.h"
#import "FunctionMenuView.h"
#import "CustomGrid.h"

@interface ChooseButtonAPI : NSObject

/**
 创建视图并初始化数据源

 @param frame frame
 @param gridDateSource 全部数据源
 @param number 首页呈现个数
 @param deleteIconImageHide 删除或者增加的图标
 @param isHomeView 是否是首页
 @param isAllData 是否是全部数据
 @param getheight 获取高度
 */
- (void)createChooseButtonFrame:(CGRect)frame gridDateSource:(NSMutableArray *)gridDateSource number:(int)number hideDeleteIconImage:(BOOL)deleteIconImageHide isHomeView:(BOOL)isHomeView isAllData:(BOOL)isAllData getheight:(void(^)(CGFloat cellheight))getheight;

/**
 视图相关事件

 @param addGridItem 添加item
 @param getlistViweHeight 获取list高度
 @param listViweClick listView点击事件
 @param listViweLongPress listView长按事件
 @param loadListViewDataSoruce listView模型数据源
 */
-(void)functionMeunViewActionWithAddGridItem:(addGridItem)addGridItem getlistViweHeight:(getlistViweHeight)getlistViweHeight listViweClick:(listViweClick)listViweClick listViweLongPress:(listViweLongPress)listViweLongPress loadListViewDataSoruce:(loadListViewDataSoruce)loadListViewDataSoruce;


/**
 获取 functionMenuView
 @return 获取 functionMenuView
 */
-(FunctionMenuView *)functionMenuView;

@end
