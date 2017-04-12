//
//  FunctionMenuView.h
//  Pods
//
//  Created by LiuYihua on 2017/4/11.
//
//

#import <UIKit/UIKit.h>
@class CustomGrid;

typedef void (^listViweClick)(CustomGrid *gridItem);
typedef void (^listViweLongPress)();

@interface FunctionMenuView : UIView

/**
 CustomGridModel 模型数组
 */
@property (nonatomic, strong) NSMutableArray * gridListDataSource;

@property (nonatomic, strong) listViweClick listViweClick;
@property (nonatomic, strong) listViweLongPress listViweLongPress;
/**
 创建视图并初始化数据源
 
 @param frame frame
 @param gridDateSource 全部数据源
 @param number 首页呈现个数
 @return 首页呈现数图
 */
- (id)initWithFrame:(CGRect)frame gridDateSource:(NSMutableArray *)gridDateSource number:(int)number;

/**
 创建功能子视图

 @param deleteIconImageHide 是否隐藏删除按钮
  @param isHomeView 是否是首页
 @param gridListDataSource 数据源
 */
- (void)createFunctionMenuViewWithHideDeleteIconImage:(BOOL)deleteIconImageHide isHomeView:(BOOL)isHomeView gridListDataSource:(NSMutableArray *)gridListDataSource;

@end
