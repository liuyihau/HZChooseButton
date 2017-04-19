//
//  CustomGrid.h
//  MoveGrid
//
//  Created by Jerry.li on 14-11-6.
//  Copyright (c) 2014年 51app. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomGrid;

@protocol CustomGridDelegate <NSObject>

//响应格子的点击事件
- (void)gridItemDidClicked:(CustomGrid *)clickItem;

//响应格子删除事件
- (void)gridItemDidDeleteClicked:(UIButton *)deleteButton selectGrid:(CustomGrid *)selectGrid;

//响应格子的长安手势事件
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(CustomGrid *) grid;

- (void)pressGestureStateChangedWithPoint:(CGPoint) gridPoint gridItem:(CustomGrid *) gridItem;

- (void)pressGestureStateEnded:(CustomGrid *) gridItem;

@end


@interface CustomGrid : UIButton
//格子的ID
@property (nonatomic, strong) NSNumber *    int_id;
//格子的title
@property (nonatomic, strong) NSString *    name;
//格子的图片
@property (nonatomic, strong) NSString *    image;
//格子的选中状态
@property (nonatomic, assign) BOOL          isChecked;
//格子的移动状态
@property (nonatomic, assign) BOOL          isMove;
//格子的排列索引位置
@property (nonatomic, assign) NSInteger     gridIndex;
//格子的位置坐标
@property (nonatomic, assign) CGPoint       gridCenterPoint;
//是否显示边框
@property (nonatomic, assign) BOOL          isShowBorder;
//全部安全中能否点击
@property (nonatomic, assign) BOOL          is_can_add;


//代理方法
@property(nonatomic, weak)id<CustomGridDelegate> delegate;


/**
 创建格子

 @param frame 尺寸
 @param normalImage 背景图片
 @param highlightedImage 背景高亮图片
 @param index 位置
 @param isAddDelete 是否添加删除按钮
 @param deleteIcon 删除图标
 @param customGridModel 格子属性
 @return 格子view
 */
- (id)initWithFrame:(CGRect)frame
        normalImage:(UIImage *)normalImage
   highlightedImage:(UIImage *)highlightedImage
            atIndex:(NSInteger)index
        isAddDelete:(BOOL)isAddDelete
         deleteIcon:(UIImage *)deleteIcon
withCustomGridModel:(CustomGrid *)customGridModel;

//根据格子的坐标计算格子的索引位置
+ (NSInteger)indexOfPoint:(CGPoint)point
               withButton:(UIButton *)btn
                gridArray:(NSMutableArray *)gridListArray;

@end


