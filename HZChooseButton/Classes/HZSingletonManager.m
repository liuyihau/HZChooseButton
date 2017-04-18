//
//  HZSingletonManager.m
//  Pods
//
//  Created by LiuYihua on 2017/4/7.
//
//

#import "HZSingletonManager.h"

@interface HZSingletonManager()

@end

static HZSingletonManager * singletonManager = nil;

@implementation HZSingletonManager
+(HZSingletonManager *)shareInstance
{
    @synchronized(self){
        if (!singletonManager) {
            singletonManager = [[self alloc]init];
        }
    }
    return singletonManager;
}



@end
