//
//  DetailsViewController.h
//  Snatch
//
//  Created by Zhanggaoju on 16/9/28.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJShoppingCartBtn.h"
@interface SDetailsViewController : UIViewController

@property (nonatomic,strong) NSString *detailurl;

@property (nonatomic,strong) UIView *carView;

@property (nonatomic,strong) GJShoppingCartBtn *cartBtn;

@property (nonatomic,strong) UIButton *goPayBtn;

@property (nonatomic,strong) NSString *number;

@property (nonatomic,strong) NSString *token;

@property (nonatomic,strong) NSDictionary *data;

@property (nonatomic,strong) NSDictionary *Qdata;

@property (nonatomic,strong) NSString *value;

@property (strong, nonatomic) NSString *urlStr;

@property (strong,nonatomic) NSURL *url ;

@property (strong,nonatomic) NSString *dataStr;

@property (nonatomic) int queue;

@end
