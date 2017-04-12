//
//  FunctionMenuView.h
//  Pods
//
//  Created by LiuYihua on 2017/4/11.
//
//

#import <UIKit/UIKit.h>

@interface FunctionMenuView : UIView

/**
 创建视图并初始化数据源
 
 @param frame frame
 @param gridDateSource 全部数据源
 @param number 首页呈现个数
 @return 首页呈现数图
 */
- (id)initWithFrame:(CGRect)frame gridDateSource:(NSMutableArray *)gridDateSource number:(int)number;

@end
