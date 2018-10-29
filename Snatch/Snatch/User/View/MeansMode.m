//
//  MeansMode.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/12/17.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "MeansMode.h"

@implementation MeansMode
-(instancetype)init{
    self =[super init];
    if (self) {
        
        
        _textData=[NSMutableArray array];
        _textData=({ NSMutableArray *array=[NSMutableArray arrayWithArray:@[@[@"夺宝头像",@"夺宝昵称",@"推荐人",@"我的二维码",@"绑定手机",@"我的收获地址"]]]; array;});
        
    }
    return self;
    
}

@end
