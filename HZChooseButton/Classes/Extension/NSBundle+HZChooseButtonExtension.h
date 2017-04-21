//
//  GitHub: https://github.com/liuyihau/HZChooseButton.git
//  NSBundle+HZChooseButtonExtension.h
//  Pods
//
//  Created by LiuYihua on 2017/4/19.
//
//

#import <Foundation/Foundation.h>

@interface NSBundle (HZChooseButtonExtension)
/**
 Get the localized string
 
 @param key     key for localized string
 @return a localized string
 
 使用  searchBar.placeholder = [NSBundle hz_localizedStringForKey:HZChooseButtonText];
 HZChooseButtonExtensionText const中的宏常量
 
 
 */
+ (NSString *)hz_localizedStringForKey:(NSString *)key;

/**
 Get the path of `HZChooseButton.bundle`.
 
 @return path of the `HZChooseButton.bundle`
 */
+ (NSBundle *)hz_chooseButtonBundle;

/**
 Get the image in the `HZChooseButton.bundle` path
 
 @param name name of image
 @return a image
 */
+ (UIImage *)hz_imageNamed:(NSString *)name;
@end
