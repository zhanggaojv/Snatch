//
//  UserInfoModel.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/7.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

-(void)setHeadimgurl:(NSString *)headimgurl{
    
    _imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",headimgurl]];
}

@end
