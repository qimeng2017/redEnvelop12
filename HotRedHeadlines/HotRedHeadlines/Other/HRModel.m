//
//  HRModel.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/21.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRModel.h"
#import <objc/runtime.h>
@implementation HRModel
- (NSDictionary *)properties
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int index = 0; index < count; index ++) {
        
        objc_property_t property = properties[index];
        const char *char_name = property_getName(property);//获取属性名
        NSString *propertyName = [NSString stringWithUTF8String:char_name];
        
        id propertyValue = [self valueForKey:propertyName];//属性值
        if (propertyValue) {
            [dict setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    
    return dict;
}

- (NSString *)description
{
    return [[self properties] description];
}

- (void)updateDataFromDictionary:(NSDictionary *)dict
{
    [self setValuesForKeysWithDictionary:dict];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (![value isKindOfClass:[NSNull class]]) {
        [super setValue:value forKey:key];
        
    }
}

- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"%@值为空", key);
}

#pragma mark - 防止属性不存在时崩溃
- (void)setValue:(id)aValue forUndefinedKey:(NSString *)key
{
    NSLog(@"%s中不存在%@键值", __FILE__, key);
}
@end
