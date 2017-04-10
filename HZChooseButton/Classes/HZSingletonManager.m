//
//  HZSingletonManager.m
//  Pods
//
//  Created by LiuYihua on 2017/4/7.
//
//

#import "HZSingletonManager.h"

@implementation HZSingletonManager
+(HZSingletonManager *)shareInstance
{
    static HZSingletonManager * singletonManager = nil;
    @synchronized(self){
        if (!singletonManager) {
            singletonManager = [[HZSingletonManager alloc]init];
        }
    }
    return singletonManager;
}
@end
