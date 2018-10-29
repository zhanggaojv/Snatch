//
//  SnatchModel.h
//  Snatch
//
//  Created by Zhanggaoju on 16/9/26.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnatchModel : NSObject

@property (nonatomic,strong) NSString * ID;                     //商品期数ID

@property (nonatomic,strong) NSString * jd;                     //当前进度%

@property (nonatomic,strong) NSString * moreurl;                ///shop/more/id/2

@property (nonatomic,strong) NSString * name;                   //名称

@property (nonatomic,strong) NSString * no;                     //期数

@property (nonatomic,strong) NSString * no_count;               //0

@property (nonatomic,strong) NSString * number;                 //实际价格

@property (nonatomic,strong) NSString * pic;                    //图片

@property (nonatomic,strong) NSString * pid;                    //28127"  商品期数ID

@property (nonatomic,strong) NSString * position;               //"7"

@property (nonatomic,strong) NSString * price;                  //"36"  所需人次

@property (nonatomic,strong) NSString * sid;                    //"2"   商品ＩＤ

@property (nonatomic,strong) NSString * surplus;                //6

@property (nonatomic,strong) NSString * ten;                    //"0"　分区

@property (nonatomic,strong) NSString * ten_name;               //null

@property (nonatomic,strong) NSString * ten_restrictions;       //null

@property (nonatomic,strong) NSString * ten_restrictions_num;   //null

@property (nonatomic,strong) NSString * ten_unit;               //1

@property (nonatomic,strong) NSString * url;                    //"/shop/index/id/28127"　商品路径

@property (nonatomic,strong) NSMutableArray *user_no;           //

@property (nonatomic,strong) NSURL *imgUrl;                     //图片完整地址

@end
