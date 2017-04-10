//
//  UIImage+Extension.m
//  Pods
//
//  Created by LiuYihua on 2017/4/7.
//
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+(UIImage *)getImageWithCurrentBundle:(NSBundle *)currentBundle imageName:(NSString *)imageName{
    
    NSString *bundleName = [currentBundle.infoDictionary[@"CFBundleName"] stringByAppendingString:@".bundle"];
    NSString *path = [currentBundle pathForResource:imageName ofType:nil inDirectory:bundleName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    
    return image;
    
}

@end
