//
//  UserHeader.h
//  Snatch
//
//  Created by Zhanggaoju on 16/10/6.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
#import "UserInfoViewController.h"
#import "AnnouncementViewController.h"
#import "RedEnvelopeViewController.h"
#import "AgencyViewController.h"
#import "BalanceViewController.h"
#import "SettingViewController.h"
#import "UserMeansViewController.h"

@interface UserHeader : UIView<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImage *bgImage;

@property (nonatomic,strong) UIButton *SettingBtn;

@property (nonatomic,strong) UIButton *userPic;

@property (nonatomic,strong) UILabel *userName;

@property (nonatomic,strong) UILabel *userRecordLabel;

@property (nonatomic,strong) UILabel *userRecord;

@property (nonatomic,strong) UILabel *userGradeLabel;

@property (nonatomic,strong) UILabel *userGrade;

@property (nonatomic,strong) UIButton *userGradeBtn;

@property (nonatomic,strong) UILabel *inviteNumberLabel;

@property (nonatomic,strong) UILabel *inviteNumber;

@property (nonatomic,strong) UIButton *Sign;

@property (nonatomic,strong) NSString *SignState;

@property (nonatomic,strong) UIView *balanceAmountView;

@property (nonatomic,strong) UIImageView *balanceAmountImg;

@property (nonatomic,strong) UILabel *balanceAmountlabel;

@property (nonatomic,strong) UILabel *balanceAmount;

@property (nonatomic,strong) UIButton *balanceAmountBtn;

@property (nonatomic,strong) UIButton *redEnvelope;

@property (nonatomic,strong) UIButton *Agency;

@property (nonatomic,strong) UILabel *backLabel;

@property (nonatomic,strong) UILabel *back;

@property (nonatomic,strong) UIButton *Announcement;

@property (nonatomic,strong) UserInfoModel *userInfoModel;

@property (nonatomic,strong) UIViewController *nav;

@property (nonatomic,strong) UIImageView *dlImage;
@property (nonatomic,strong) UIImageView *jfImage;
@property (nonatomic,strong) UIImageView *yqImage;

@property (nonatomic,strong) UIButton *juewei;
@property (nonatomic,strong) UIImageView *quan;




- (void)makeScaleForScrollView:(UIScrollView *)scrollView;

@end
