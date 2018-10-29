//
//  SnatchRecordViewController.h
//  Snatch
//
//  Created by Zhanggaoju on 16/10/6.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJShoppingCartBtn.h"

@interface SnatchRecordViewController : UIViewController

@property (nonatomic,strong) NSString *Url;

@property (nonatomic,strong) NSString *token;

@property (nonatomic,strong) NSString *link;

@property (nonatomic,strong) NSString *imageurl;

@property (nonatomic,strong) NSString *titles;


@property (nonatomic,strong) UIView *carView;

@property (nonatomic,strong) GJShoppingCartBtn *cartBtn;

@property (nonatomic,strong) UIButton *goPayBtn;

@property (nonatomic,strong) NSString *number;

@property (nonatomic,strong) NSDictionary *data;

@property (nonatomic,strong) NSDictionary *Qdata;

@property (nonatomic,strong) NSString *value;

@property (nonatomic,strong) NSString *dataStr;

@property (nonatomic) int queue;


@end
