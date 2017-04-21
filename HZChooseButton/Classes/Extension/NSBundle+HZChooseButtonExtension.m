//
//  GitHub: https://github.com/liuyihau/HZChooseButton.git
//  NSBundle+HZChooseButtonExtension.m
//  Pods
//
//  Created by LiuYihua on 2017/4/19.
//
//

#import "NSBundle+HZChooseButtonExtension.h"
#import "ChooseButtonViewController.h"

@implementation NSBundle (HZChooseButtonExtension)

+ (NSBundle *)hz_chooseButtonBundle
{
    static NSBundle *searchBundle = nil;
    if (nil == searchBundle) {
        //Default use `[NSBundle mainBundle]`.
        searchBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"HZChooseButton" ofType:@"bundle"]];
        /**
         If you use pod import and configure `use_frameworks` in Podfile, [NSBundle mainBundle] does not load the `hzSearch.fundle` resource file in `HZChooseButton.framework`.
         
         */
        if (nil == searchBundle) { // Empty description resource file in `hzSearch.framework`.
            searchBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[ChooseButtonViewController class]] pathForResource:@"HZChooseButton" ofType:@"bundle"]];
        }
    }
    return searchBundle;
}

+ (NSString *)hz_localizedStringForKey:(NSString *)key;
{
    return [self hz_localizedStringForKey:key value:nil];
}

+ (NSString *)hz_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    if (nil == bundle) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) language = @"en";
        else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans";
            } else {
                language = @"zh-Hant";
            }
        } else {
            language = @"en";
        }
        
        // Find resources from `hzSearch.bundle`
        bundle = [NSBundle bundleWithPath:[[NSBundle hz_chooseButtonBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
    
 
}

+ (UIImage *)hz_imageNamed:(NSString *)name
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    name = 3.0 == scale ? [NSString stringWithFormat:@"%@@3x.png", name] : [NSString stringWithFormat:@"%@@2x.png", name];
    UIImage *image = [UIImage imageWithContentsOfFile:[[[NSBundle hz_chooseButtonBundle] resourcePath] stringByAppendingPathComponent:name]];
    return image;
}

@end

