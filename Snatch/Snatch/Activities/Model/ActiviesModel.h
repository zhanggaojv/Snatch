//
//  ActiviesModel.h
//  Snatch
//
//  Created by Zhanggaoju on 16/9/30.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActiviesModel : NSObject

@property (nonatomic,strong) NSString * ID;

@property (nonatomic,strong) NSString * title;

@property (nonatomic,strong) NSString * picurl;

@property (nonatomic,strong) NSString * remark;

@property (nonatomic,strong) NSString * icon;

@property (nonatomic,strong) NSString * end_time;

@property (nonatomic,strong) NSURL *imgUrl;                     //图片完整地址

@property (nonatomic,strong) NSString *link;


@end
