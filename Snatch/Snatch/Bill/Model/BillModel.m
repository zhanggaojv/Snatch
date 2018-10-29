//
//  BillModel.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/5.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "BillModel.h"

@implementation BillModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
-(void)setImg:(NSString *)img{
    
    _imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",img]];
}

@end
