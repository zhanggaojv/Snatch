//
//  ActiviesModel.m
//  Snatch
//
//  Created by Zhanggaoju on 16/9/30.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "ActiviesModel.h"

@implementation ActiviesModel
//替换特殊字符
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

-(void)setPicurl:(NSString *)picurl{
    
    _imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_BASE,picurl]];
    
}
@end
