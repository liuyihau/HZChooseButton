//
//  HZSingletonManager.h
//  Pods
//
//  Created by LiuYihua on 2017/4/7.
//
//

#import <Foundation/Foundation.h>

@interface HZSingletonManager : NSObject
// 主页 按钮 数组
@property (strong,nonatomic) NSMutableArray * showGridArray; // 标题
@property (strong,nonatomic) NSMutableArray * showImageGridArray; // 图片
@property (strong,nonatomic) NSMutableArray * showGridIDArray;  //button的ID


+(HZSingletonManager *)shareInstance;
@end
