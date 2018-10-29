//
//  MenuList.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/11/16.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "MenuList.h"

@implementation MenuList
-(instancetype)init{
    self =[super init];
    if (self) {
        
        
        _textData=[NSMutableArray array];
        _textData=({ NSMutableArray *array=[NSMutableArray arrayWithArray:@[@[@"全部商品",@"手机平板",@"电脑办公",@"数码影音",@"女性时尚",@"美食天地",@"潮流新品",@"其他商品"]]]; array;});
        
        _imageData=[NSMutableArray array];
        _imageData=({ NSMutableArray *array=[NSMutableArray arrayWithArray:@[@[@"daohanglan-",@"shouji",@"dinanaobangong-",@"shumayingyin-",@"nvxingshishang",@"meishitiandi",@"chaoliuxinpin-",@"qita-"]]]; array;});
        
    }
    return self;
    
}

@end
