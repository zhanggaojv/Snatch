//
//  Menudata.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/6.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "Menudata.h"

@implementation Menudata
-(instancetype)init{
    self =[super init];
    if (self) {
    

    _textData=[NSMutableArray array];
    _textData=({ NSMutableArray *array=[NSMutableArray arrayWithArray:@[@[@"一键加群"],@[@"夺宝成绩单",@"夺宝明细",@"中奖记录",@"分组夺宝",@"积分兑换"],@[@"我的红包",@"邀请好友",@"地址管理",@"绑定手机"],@[@"个人设置"]]]; array;});
        
    _imageData=[NSMutableArray array];
    _imageData=({ NSMutableArray *array=[NSMutableArray arrayWithArray:@[@[@"qun0"],@[@"chengjidan",@"duobaojilu",@"zhongjiangjilu",@"jiheduobao",@"zhiguo"],@[@"hongbao",@"yaoqinghaoyou",@"dizhiguanli",@"phone"],@[@"shezhi"]]]; array;});
       
    }
    return self;
    
}

@end

//,@[@"积分记录",@"直购记录",@"邀请记录"]
//,@[@"jifenjilv",@"zhigoujilv",@"yaoqingjilv"]

//,@[@"绑定手机",@"跟拍设置",@"地址管理"]
//,@[@"bangdingshouji",@"genpaishezhi",@"dizhiguanli"]
