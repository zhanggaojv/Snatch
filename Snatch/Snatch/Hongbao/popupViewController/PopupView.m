//
//  PopupView.m
//  LewPopupViewController
//
//  Created by deng on 15/3/5.
//  Copyright (c) 2015年 pljhonglu. All rights reserved.
//

#import "PopupView.h"
#import "UIViewController+LewPopupViewController.h"

#import "LewPopupViewAnimationSlide.h"



@implementation PopupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
   
        _innerView=[[UIView alloc]initWithFrame:self.bounds];
        _innerView.layer.masksToBounds=YES;
        _innerView.layer.cornerRadius = 5;
        _innerView.backgroundColor=[UIColor whiteSmoke];
        [self addSubview:_innerView];
        
        
        UILabel *label=[[UILabel alloc]init];
        label.text=@"快捷登录";
        label.textColor=[UIColor colorWithHexString:@"428bca"];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:16 weight:1];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_innerView.mas_top).mas_offset(10);
            make.centerX.mas_equalTo(_innerView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        
        UIButton *qqBtn=[[UIButton alloc]init];
        [qqBtn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [self addSubview:qqBtn];
        [qqBtn addTarget:self action:@selector(onLoginQQBtn:) forControlEvents:UIControlEventTouchUpInside];
        [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label.mas_bottom).mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.left.mas_equalTo((_innerView.width-100)/3);
        }];
        
        UIButton *wechatBtn=[[UIButton alloc]init];
        [wechatBtn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        [self addSubview:wechatBtn];
        [wechatBtn addTarget:self action:@selector(onLoginWXBtn:) forControlEvents:UIControlEventTouchUpInside];
        [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label.mas_bottom).mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.right.mas_equalTo(-((_innerView.width-100)/3));
        }];


    }
    return self;
}

-(void)onLoginQQBtn:(UIButton *)btn{
    [_parentVC lew_dismissPopupView];
    
    [self QQBtnClick];
    
    _parentVC.navigationController.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [_parentVC lew_dismissPopupView];
    
    
}
-(void)onLoginWXBtn:(UIButton *)btn{
    [self WeiXinBtnClick];
    _parentVC.navigationController.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [_parentVC lew_dismissPopupView];
}

+ (instancetype)defaultPopupView{
    return [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-200, [UIScreen mainScreen].bounds.size.width-250)];
}
-(void)QQBtnClick
{
    [[UMSocialManager defaultManager]  authWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        NSString *message = nil;
        if (error) {
            NSLog(@"Auth fail with error %@", error);
            message = @"Auth fail";
        }else{
            if ([result isKindOfClass:[UMSocialAuthResponse class]]) {
                
                [self getQQUserInfoForPlatform];
            }else{
                NSLog(@"Auth fail with unknow error");
                message = @"Auth fail";
            }
        }
        
        
    }];
    
}
-(void)getQQUserInfoForPlatform{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        UMSocialResponse *userinfo =result;
        NSLog(@"22 %@", userinfo.originalResponse);
        [self QQLogin:userinfo];
    }];
    
}
-(void)QQLogin:(UMSocialResponse*)userinfo{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"openid"] = userinfo.openid;
    mDic[@"inviteCode"] =@"";
    mDic[@"nickname"] = userinfo.originalResponse[@"nickname"];
    mDic[@"figureurl_qq_2"] = userinfo.originalResponse[@"figureurl_qq_2"];
    mDic[@"city"] = userinfo.originalResponse[@"city"];
    mDic[@"province"] = userinfo.originalResponse[@"province"];
    mDic[@"gender"] = userinfo.originalResponse[@"gender"];
    NSDictionary *dic=@{@"code":@"qqLogin",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result){
        NSLog(@"__11 %@",result);
        NSDictionary *dic =(NSDictionary *)result;
        
        [GJTokenManager saveToken:dic[@"token"]];
        // [FormValidator showAlertWithStr:@"QQ登录成功"];
        //用户名密码输入正确后，登录后需要跳转的页面
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userViewGoto" object:nil userInfo:dic];
        
    } failure:^(NSError *erro) {
        NSLog(@"请求错误%@",erro);
        [FormValidator showAlertWithStr:failTipe];
        
    } showHUD:nil];
    
}

-(void)WeiXinBtnClick
{
    [[UMSocialManager defaultManager]  authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        NSString *message = nil;
        if (error) {
            NSLog(@"Auth fail with error %@", error);
            message = @"Auth fail";
        }else{
            if ([result isKindOfClass:[UMSocialAuthResponse class]]) {
                UMSocialAuthResponse *resp = result;
                // 授权信息
                NSLog(@"AuthResponse uid: %@", resp.uid);
                NSLog(@"AuthResponse accessToken: %@", resp.accessToken);
                NSLog(@"AuthResponse refreshToken: %@", resp.refreshToken);
                NSLog(@"AuthResponse expiration: %@", resp.expiration);
                
                // 第三方平台SDK源数据,具体内容视平台而定
                NSLog(@"AuthOriginalResponse: %@", resp.originalResponse);
                //                message = [NSString stringWithFormat:@"result: %d\n uid: %@\n accessToken: %@\n",(int)error.code,resp.uid,resp.accessToken];
                [self getWXUserInfoForPlatform];
            }else{
                NSLog(@"Auth fail with unknow error");
                message = @"Auth fail";
            }
        }
        
        
    }];
}

-(void)getWXUserInfoForPlatform{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        UMSocialResponse *userinfo =result;
        NSLog(@"%@", userinfo.originalResponse);
        [self WXLogin:userinfo];
    }];
}

-(void)WXLogin:(UMSocialResponse*)userinfo{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"unionid"] = userinfo.originalResponse[@"unionid"];
    mDic[@"inviteCode"] =@"";
    mDic[@"sex"] = userinfo.originalResponse[@"sex"];
    mDic[@"nickname"] = userinfo.originalResponse[@"nickname"];
    mDic[@"headimgurl"] = userinfo.originalResponse[@"headimgurl"];
    mDic[@"city"] = userinfo.originalResponse[@"city"];
    mDic[@"province"] = userinfo.originalResponse[@"province"];
    mDic[@"country"] = userinfo.originalResponse[@"country"];
    NSDictionary *dic=@{@"code":@"wxLogin",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result){
        NSLog(@"________%@",result);
        NSDictionary *dic =(NSDictionary *)result;
        
        [GJTokenManager saveToken:dic[@"token"]];
        // [FormValidator showAlertWithStr:@"微信登录成功"];
        //用户名密码输入正确后，登录后需要跳转的页面
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userViewGoto" object:nil userInfo:dic];
        
    } failure:^(NSError *erro) {
        NSLog(@"请求错误%@",erro);
        [FormValidator showAlertWithStr:failTipe];
        
    } showHUD:nil];
    
}
-(void)XinLangBtnClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新浪微博登陆" message:@"该功能正在开发，给你带来不便请见谅" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];

}


- (IBAction)dismissAction:(id)sender{
    [_parentVC lew_dismissPopupView];
}


@end
