//
//  CustomGrid.h
//  MoveGrid
//
//  Created by Jerry.li on 14-11-6.
//  Copyright (c) 2014年 51app. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomGridModel;

//每个格子的X轴间隔
#define PaddingX 10
//每个格子的Y轴间隔
#define PaddingY 10

//每行显示格子的列数
#define PerRowGridCount 4
//每列显示格子的行数
#define PerColumGridCount 6
//每个格子的宽度
#define GridWidth ((ScreenWidth-50)/PerRowGridCount)


@protocol CustomGridDelegate;

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
 * 创建格子
 * @param pointX   格子所在位置的X坐标
 * @param pointY   格子所在位置的Y坐标
 * @param gridId   格子的ID
 * @param index    格子所在位置的索引下标
 * @param isDelete 是否增加删除图标
 */
- (id)initWithFrame:(CGRect)frame
        normalImage:(UIImage *)normalImage
   highlightedImage:(UIImage *)highlightedImage
            atIndex:(NSInteger)index
        isAddDelete:(BOOL)isAddDelete
         deleteIcon:(UIImage *)deleteIcon
withCustomGridModel:(CustomGridModel *)customGridModel;

//根据格子的坐标计算格子的索引位置
+ (NSInteger)indexOfPoint:(CGPoint)point
               withButton:(UIButton *)btn
                gridArray:(NSMutableArray *)gridListArray;

@end

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


