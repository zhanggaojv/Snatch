//
//  AnnounceModel.h
//  Snatch
//
//  Created by Zhanggaoju on 16/9/27.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnounceModel : NSObject

@property (nonatomic,strong) NSString * Auto;                     //自动

@property (nonatomic,strong) NSString * buy_price;                //购买价格

@property (nonatomic,strong) NSString * buy_url;                  //购买路径

@property (nonatomic,strong) NSString * category;                 //"13"

@property (nonatomic,strong) NSString * cid;                      //"13"

@property (nonatomic,strong) NSString * Conten;                   //"&lt;p&gt;&lt;img

@property (nonatomic,strong) NSString * count;                    //null

@property (nonatomic,strong) NSString * create_time;              //"1452700800"建立时间

@property (nonatomic,strong) NSString * ctitle;                   //"其他商品"商品分类

@property (nonatomic,strong) NSString * Description;              //描述

@property (nonatomic,strong) NSString * djtype;                   //"0"

@property (nonatomic,strong) NSString * edit_price;               //修改过的价格

@property (nonatomic,strong) NSString * end_time;                 //"1474420202766"开奖时间

@property (nonatomic,strong) NSString * hits;                     //"1129"热度

@property (nonatomic,strong) NSString * ID;                       //当前期ＩＤ

@property (nonatomic,strong) NSString * jd;                       //100进度

@property (nonatomic,strong) NSString * kaijang_diffe;            //2985000时间差

@property (nonatomic,strong) NSString * kaijang_num;     //开奖号

@property (nonatomic,strong) NSString * kaijang_time;             //"09-21 10:04"开奖时间

@property (nonatomic,strong) NSString * kaijang_timing;           //"1474423440"

@property (nonatomic,strong) NSString *kaijiang_count;            //"4541620094"

@property (nonatomic,strong) NSString * keywords;                 //

@property (nonatomic,strong) NSString * meta_title;               //

@property (nonatomic,strong) NSString * moreurl;                  //"/shop/more/id/370"

@property (nonatomic,strong) NSString * name;                     //名称

@property (nonatomic,strong) NSString * number;                   //投入人次

@property (nonatomic,strong) NSString * pic;                      //图片

@property (nonatomic,strong) NSString * pid;                      //产品号

@property (nonatomic,strong) NSString * position;                 //"0"

@property (nonatomic,strong) NSString * price;                    //需购买人次

@property (nonatomic,strong) NSString * queue;                    //分队数，2以上是集合夺宝

@property (nonatomic,strong) NSString * shared;                   //

@property (nonatomic,strong) NSString * sid;                      //商品ID

@property (nonatomic,strong) NSString * no;

@property (nonatomic,strong) NSString * state;                    //"1"

@property (nonatomic,strong) NSString * surplus;                  //0

@property (nonatomic,strong) NSString * ten;                      //"0"
@property (nonatomic,strong) NSString * uid;                      //"0"

@property (nonatomic,strong) NSString * url;                      //商品明细路径

@property (nonatomic,strong) NSString * user;                     //null 中奖用户 null为未 开奖

@property (nonatomic,strong) NSString * user_pic;                 //"http://dnsa.daliuliang.com.cn"

@property (nonatomic,strong) NSMutableArray *user_no;           //

@property (nonatomic,strong) NSURL *imgUrl;                     //图片完整地址

@end
