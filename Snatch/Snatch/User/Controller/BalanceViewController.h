//
//  BalanceViewController.h
//  Snatch
//
//  Created by Zhanggaoju on 16/10/7.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceViewController : UIViewController

@property (nonatomic,strong) UILabel *moneyWay;

@property (nonatomic,strong) UITextField *money;

@property (nonatomic,strong) NSMutableArray *btnArr;

@property (nonatomic,strong) NSString *pay;

@property (nonatomic,strong) UILabel *playWay;

@property (nonatomic,strong) UIImageView *way;

@property (nonatomic,strong) UILabel *WXPlay;

@property (nonatomic,strong) NSString *token;

@property (nonatomic,strong) NSMutableDictionary *wxData;


@property (nonatomic,weak) UIButton *selBtn;

@property (nonatomic,weak) NSMutableArray *viewArr;

@property (nonatomic,strong) UILabel *Wlabel;

@property (nonatomic,strong) UIButton *WXPay;

@property (nonatomic,strong) UILabel *Zlabel;

@property (nonatomic,strong) UIButton *ZPay;

@property (nonatomic) int select;
@end
