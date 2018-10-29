//
//  AnnounceModel.m
//  Snatch
//
//  Created by Zhanggaoju on 16/9/27.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "AnnounceModel.h"

@class AnnUserModel;
@implementation AnnounceModel

+(void)load{
    
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"Auto":@"auto",@"ID" : @"id",@"Description":@"description"
                 };
    }];
}

+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"user_no" : @"AnnUserModel",
             };
}


-(void)setPic:(NSString *)pic{
    _imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",pic]];
    
}

@end
