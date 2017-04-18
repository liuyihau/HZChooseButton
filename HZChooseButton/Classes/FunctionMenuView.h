//
//  FunctionMenuView.h
//  Pods
//
//  Created by LiuYihua on 2017/4/11.
//
//

#import <UIKit/UIKit.h>
@class CustomGrid;
typedef void (^loadListViewDataSoruce)(NSMutableArray * dateSource);
typedef void (^addGridItem)(CustomGrid *gridItem);
typedef void (^getlistViweHeight)(CGFloat cellHeight,CustomGrid *gridItem,BOOL allGridBtnImageChange);
typedef void (^listViweClick)(CustomGrid *gridItem);
typedef void (^listViweLongPress)(CustomGrid *gridItem);


@interface FunctionMenuView : UIView

/**
 CustomGridModel 模型数组
 */
@property (nonatomic, strong) NSMutableArray * gridListDataSource;

/**
 是否是首页
 */
@property (nonatomic, assign) BOOL isHomeView;

/**
 刷新首页数据源
 */
@property (nonatomic, copy) loadListViewDataSoruce  loadListViewDataSoruce;

/**
 添加应用
 */
@property (nonatomic, copy) addGridItem addGridItem;

/**
 获取视图高度
 */
@property (nonatomic, copy) getlistViweHeight getlistViweHeight;

/**
 视图点击
 */
@property (nonatomic, copy) listViweClick listViweClick;

/**
 视图长按
 */
@property (nonatomic, copy) listViweLongPress listViweLongPress;


/**
 functionMeunView   相关的操作事件

 @param addGridItem  添加应用
 @param getlistViweHeight 获取视图高度
 @param listViweClick 视图点击
 @param listViweLongPress  视图长按
 @param loadListViewDataSoruce  刷新首页数据源
 */
-(void)functionMeunViewActionWithAddGridItem:(addGridItem)addGridItem getlistViweHeight:(getlistViweHeight)getlistViweHeight listViweClick:(listViweClick)listViweClick listViweLongPress:(listViweLongPress)listViweLongPress loadListViewDataSoruce:(loadListViewDataSoruce)loadListViewDataSoruce;


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
  @return cell高度
 */
- (CGFloat)createFunctionMenuViewWithHideDeleteIconImage:(BOOL)deleteIconImageHide isHomeView:(BOOL)isHomeView gridListDataSource:(NSMutableArray *)gridListDataSource;

/**
 我的应用  页面更新

 @param hideNameLabel 提示文字隐藏判断
 @param gridListDataSource 数据源
 @return 高度
 */
-(CGFloat)loadGridListViewWithHideNameLabel:(BOOL)hideNameLabel gridListDataSource:(NSMutableArray *)gridListDataSource;

/**
 编辑及完成操作方法
 
 @param isPrompthidden 是否隐藏 提示语句
 @param allGridListView 是否是全部应用
 @param animated        动画
 */
-(void)editGridListViewWithPrompthidden:(BOOL)isPrompthidden isAllGridListView:(BOOL)allGridListView showGridArray:(NSMutableArray *)showGridArray animated:(BOOL)animated;

/**
 我的应用删除，改变全部应用中的某个应用

 @param selectGrid 删除的应用信息
 */
-(void)setAllGridlistViewGridItemChangeWithSelectGrid:(CustomGrid *)selectGrid;
/**
 添加item到我的应用中
 
 @param selectGrid 选择的项目
 */
-(void)addGridItemToMyGridListViewWithselectGrid:(CustomGrid *)selectGrid;



@end
