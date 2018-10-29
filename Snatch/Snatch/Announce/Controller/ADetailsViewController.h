//
//  DetailsViewController.h
//  Snatch
//
//  Created by Zhanggaoju on 16/9/28.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJShoppingCartBtn.h"

@interface ADetailsViewController : UIViewController

@property (nonatomic,strong) NSString *detailurl;

@property (nonatomic,strong) NSString *token;

@property (nonatomic,strong) UIView *carView;

@property (nonatomic,strong) GJShoppingCartBtn *cartBtn;

@property (nonatomic,strong) UIButton *goPayBtn;

@property (nonatomic,strong) NSString *number;

@property (nonatomic,strong) NSDictionary *data;

@property (nonatomic,strong) NSDictionary *Qdata;

@property (nonatomic,strong) NSString *value;

@property (nonatomic,strong) NSString *dataStr;

@property (nonatomic) int queue;

@property ( nonatomic) BOOL isback;

@end
