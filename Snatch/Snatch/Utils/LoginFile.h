//
//  Header.h
//  Snatch
//
//  Created by Zhanggaoju on 16/10/8.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define whitesColor [UIColor whiteColor]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width/320.0
#define Height [UIScreen mainScreen].bounds.size.height/568.0
#import "UILabel+Extension.h"
#import "UIButton+Extension.h"
#import "UIImageView+Extension.h"
#import "LoginViewController.h"
#import "RechargeViewController.h"
#import "ForgetPassViewController.h"
#import "AFNetworking.h"
#import "FormValidator.h"
#import "SHInvoker.h"
#import "UITextField+Extension.h"
#define failTipe @"网络开小差了，稍后试试吧"
//注册
#define registAccount @""
//登陆
#define loginAccount @""
//验证码接口
#define validate @""
//忘记密码接口
#define forgetPassW @""


#endif /* Header_h */
