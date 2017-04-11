//
//  HZSingletonManager.h
//  Pods
//
//  Created by LiuYihua on 2017/4/7.
//
//

#import <Foundation/Foundation.h>

@interface HZSingletonManager : NSObject

@property (strong,nonatomic) NSMutableArray * gridDateSource; // Grid所有数据

@property (strong,nonatomic) NSMutableArray * myGridArray; // 我的应用 数据

+(HZSingletonManager *)shareInstance;

@end
