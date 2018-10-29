//
//  SnatchModel.m
//  Snatch
//
//  Created by Zhanggaoju on 16/9/26.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "SnatchModel.h"
@class UserModel;
@implementation SnatchModel

+(void)load{
    
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
}

+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"user_no" : @"UserModel",
             };
}


-(void)setPic:(NSString *)pic{
    _imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",pic]];

}

@end
