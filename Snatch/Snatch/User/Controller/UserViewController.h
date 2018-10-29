//
//  UserViewController.h
//  夺你所爱
//
//  Created by Zhanggaoju on 16/9/20.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SnatchRecordViewController.h"
#import "LuckyRecordViewController.h"
#import "GroupViewController.h"
#import "InvitationViewController.h"
#import "AddressViewController.h"
#import "RechargeViewController.h"
#import "ScoresViewController.h"
#import "PhoneViewController.h"
#import "FriendRecordViewController.h"
#import "BuyViewController.h"
#import "AuctionViewController.h"
#import "ShareViewController.h"
#import "SettingViewController.h"
#import "ErweimaViewController.h"


@interface UserViewController : baseViewController

@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSMutableDictionary *data;

@property (nonatomic, strong) NSString *phone;

@property (strong, nonatomic) UIView *contentView;

@end
