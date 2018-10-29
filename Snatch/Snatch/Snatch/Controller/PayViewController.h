//
//  PayViewController.h
//  Snatch
//
//  Created by Zhanggaoju on 16/10/14.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayResultViewController.h"

@interface PayViewController : UIViewController 

@property (nonatomic,strong) UILabel *name;

@property (nonatomic,strong) UILabel *ALable;

@property (nonatomic,strong) UILabel *payAmount;

@property (nonatomic,strong) UILabel *BLabel;

@property (nonatomic,strong) UIButton *balancePay;

@property (nonatomic,strong) UILabel *balance;

@property (nonatomic,strong) UILabel *Wlabel;

@property (nonatomic,strong) UIButton *WXPay;

@property (nonatomic,strong) UILabel *Zlabel;

@property (nonatomic,strong) UIButton *ZPay;

@property (nonatomic,strong) UILabel *Jlabel;

@property (nonatomic,strong) UIButton *JPay;


@property (nonatomic,strong) UIButton *phone;

@property (nonatomic,strong) UILabel *PLabel;

@property (nonatomic,strong) UIButton *pay;

@property (nonatomic,strong) NSMutableArray *viewArr;

@property (nonatomic,strong) NSString *number;

@property (nonatomic,strong) NSMutableDictionary *data;

@property (nonatomic,strong) NSString *value;

@property (nonatomic,strong) NSString *pid;

@property (nonatomic,strong) NSString *queue;

@property (nonatomic,strong) NSString *zg;

@property (nonatomic,strong) NSString *token;

@property (nonatomic) int select;

@property (nonatomic,strong) NSMutableDictionary *wxData;

@property (nonatomic,strong) NSMutableDictionary *wxWebData;

@property (nonatomic,strong) NSString *url;

@property (nonatomic,strong) NSString *hb_money;

@property (nonatomic,strong) NSString *hbid;

@property (nonatomic,strong) UILabel *yhLabel;

@property (nonatomic,strong) NSString *splay;

@end
