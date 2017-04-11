//
//  CustomGridModel.m
//  Pods
//
//  Created by LiuYihua on 2017/4/11.
//
//

#import "CustomGridModel.h"

@implementation CustomGridModel
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _image = [aDecoder decodeObjectForKey:@"_image"];
        _int_id = [aDecoder decodeObjectForKey:@"_int_id"];
        _name = [aDecoder decodeObjectForKey:@"_name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.image forKey:@"_image"];
    [aCoder encodeObject:self.int_id forKey:@"_int_id"];
    [aCoder encodeObject:self.name forKey:@"_name"];
}
@end
