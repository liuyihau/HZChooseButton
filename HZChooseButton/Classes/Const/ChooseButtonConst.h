//
//  GitHub: https://github.com/liuyihau/HZChooseButton.git
//  ChooseButtonConst.h
//  Pods
//
//  Created by LiuYihua on 2017/4/12.
//
//

#import <Foundation/Foundation.h>
#ifdef DEBUG
#define NSLog( s, ... ) NSLog( @"========<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog( s, ... )
#endif

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define UICOLOR_RGB(R,G,B)        ([UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1])
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 随机色
#define  RGBRandomColor UICOLOR_RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

////颜色  ! 参数格式为：0xFFFFFF
#define RandomColorWithRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define ISIPHONE5s ( [UIScreen mainScreen].bounds.size.width >=320 && [UIScreen mainScreen].bounds.size.width <375)




@interface ChooseButtonConst : NSObject

@end
