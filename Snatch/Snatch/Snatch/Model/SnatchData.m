//
//  SnatchData.m
//  Snatch
//
//  Created by 袁伟森 on 2016/9/26.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "SnatchData.h"

@implementation SnatchData

//替换特殊字符
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"data" : @"SnatchModel",
             };
}

@end
