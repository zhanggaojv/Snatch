//
//  PopupView.h
//  LewPopupViewController
//
//  Created by deng on 15/3/5.
//  Copyright (c) 2015年 pljhonglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView



@property (nonatomic, strong) UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
- (IBAction)onLoginBtn:(UIButton *)sender;
- (IBAction)onRegistBtn:(UIButton *)sender;

@property (nonatomic,strong) NSString *token;
+ (instancetype)defaultPopupView;
@end
