//
//  SettingMenuData.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/10.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "SettingMenuData.h"

@implementation SettingMenuData
-(instancetype)init{
    self =[super init];
    if (self) {
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSString *newver = [userDefault objectForKey:@"newver"];
        
        
        if (IFNEWVER) {
        _textData=[NSMutableArray array];
            _textData=({ NSMutableArray *array=[NSMutableArray arrayWithArray:@[@[@"关于我们",@"联系我们",@"常见问题"],@[@"清除缓存",@"版本更新"]]]; array;});
        }else{
           _textData=({ NSMutableArray *array=[NSMutableArray arrayWithArray:@[@[@"关于我们",@"联系我们",@"常见问题"],]]; array;});
            
        }
    }
    return self;
    
}

@end
//,@[@"积分记录",@"直购记录",@"邀请记录"]
//,@[@"jifenjilv",@"zhigoujilv",@"yaoqingjilv"]


//,@[@"bangdingshouji",@"genpaishezhi",@"dizhiguanli"]
