//
//  LoginVCNew.m
//  易林Video
//
//  Created by beijingduanluo on 15/12/19.
//  Copyright © 2015年 beijingduanluo. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPassViewController.h"
#import "BlackVideoViewController.h"
#import "UserViewController.h"
#import "BillViewController.h"
#import "GJTokenManager.h"



@interface LoginViewController ()
@property(nonatomic,strong)UIImageView *backImgV;
@property(nonatomic,strong)UIImageView *backView;
@property(nonatomic,strong)UITextField *phoneTextField;
@property(nonatomic,strong)UIImageView *phoneImgV;
@property(nonatomic,strong)UITextField *passwordText;
@property(nonatomic,strong)UIImageView *passwordImgV;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIButton *forgetPassWordBtn;
@property(nonatomic,strong)UIButton *registBtn;
@property(nonatomic,strong)UIImageView *headImgV;
@property(nonatomic,strong)UIButton *returnTopBtn;

@property (nonatomic ,strong) UIImageView *lognline;
@property (nonatomic ,strong)UIButton *QQBtn;
@property (nonatomic ,strong)UIButton *WeiXinBtn;
@property (nonatomic ,strong)UIButton *XinLangBtn;

@property (nonatomic ) BOOL ret;


@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view=[super view];
    
   
    _backImgV =[UIImageView addImgWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-42) AndImage:@"beijing"];
    [self.view addSubview:_backImgV];
    _backImgV.userInteractionEnabled = YES;
    
    GJSCRollBACKView *wsRoll = [[GJSCRollBACKView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    wsRoll.backgroundColor = [UIColor whiteColor];
    wsRoll.timeInterval = 0.05; //移动一次需要的时间
    wsRoll.rollSpace = 0.5; //每次移动的像素距离
    wsRoll.direction = RollDirectionLeftRight;//滚动的方向
    wsRoll.image = [UIImage imageNamed:@"555.jpg"];//本地图片
    //    wsRoll.rollImageURL = @"http://jiangsu.china.com.cn/uploadfile/2016/0122/1453449251090847.jpg"; //网络图片地址
    [wsRoll startRoll]; //开始滚动
    [self.view addSubview:wsRoll];
    
    // blur效果(毛玻璃)
//    UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    visualEfView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    visualEfView.alpha = 0.7;
//    [_backImgV addSubview:visualEfView];
    
    _backView =[UIImageView addImgWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-42) AndImage:nil];
    [self.view addSubview:_backView];
    _backView.userInteractionEnabled = YES;
    _backView.backgroundColor=[UIColor clearColor];
    
    
    UIImageView *tubiaoImage=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2,100, 80, 80)];
    tubiaoImage.image=[UIImage imageNamed:@"tubiao"];
    tubiaoImage.layer.masksToBounds=YES;
    tubiaoImage.layer.cornerRadius=40;
    tubiaoImage.layer.borderWidth=1;
    tubiaoImage.layer.borderColor=[UIColor clearColor].CGColor;
    [_backView addSubview:tubiaoImage];
    
    
    _phoneTextField =[self addtextFieldWithHeight:180 AndImgStr:@"loginText" AndStr:@"请输入手机号码"];
    _phoneTextField.keyboardType =UIKeyboardTypeNumberPad;
    [_backView addSubview:_phoneTextField];
    _phoneTextField.textAlignment=NSTextAlignmentCenter;
//    UIButton *clearButton = [_phoneTextField valueForKey:@"_clearButton"];
//    [clearButton setImage:[UIImage imageNamed:@"icon_blueclear"] forState:UIControlStateNormal];
    _phoneTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    _passwordText =[self addtextFieldWithHeight:230 AndImgStr:@"loginText" AndStr:@"请输入密码"];
    _passwordText.secureTextEntry = YES;
    
    [_backView addSubview:_passwordText];
    _passwordText.textAlignment=NSTextAlignmentCenter;
//    UIButton *passwordclearButton = [_phoneTextField valueForKey:@"_clearButton"];
//    [passwordclearButton setImage:[UIImage imageNamed:@"icon_blueclear"] forState:UIControlStateNormal];
    _passwordText.clearButtonMode = UITextFieldViewModeAlways;
    
    
    
    _loginBtn =[UIButton addBtnImage:@"loginBtn" AndFrame:CGRectMake(30*Width, 300*Height-20, 260*Width, 36*Height) WithTarget:self action:@selector(loginAccountButton)];
    [_backView addSubview:_loginBtn];
    
    _forgetPassWordBtn =[UIButton addBtnImage:@"forgetPassWord" AndFrame:CGRectMake(215*Width, 340*Height-20, 90*Width, 20*Height) WithTarget:self action:@selector(forgetPasswordClick)];
    //[_forgetPassWordBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    _forgetPassWordBtn.titleLabel.font =[UIFont systemFontOfSize:12*Width weight:0.5];
    [_backView addSubview:_forgetPassWordBtn];
    
    _registBtn =[UIButton addBtnImage:@"gotoRegister" AndFrame:CGRectMake(Width, 340*Height-20, 100*Width, 20*Height) WithTarget:self action:@selector(registAccountInterface)];
    [_backView addSubview:_registBtn];
    
   
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *newver = [userDefault objectForKey:@"newver"];
    

    if (IFNEWVER) {
    _lognline=[[UIImageView alloc]initWithFrame:CGRectMake(10, 340*Height+50, SCREEN_WIDTH-20, 12)];
    _lognline.image=[UIImage imageNamed:@"loginLien"];
    [self.view addSubview:_lognline];
        
    _QQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _QQBtn.frame = CGRectMake((self.view.frame.size.width - 50)/2, SCREEN_HEIGHT-150, 50, 50);
    _QQBtn.layer.cornerRadius = 25;
    [_QQBtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [_QQBtn addTarget:self action:@selector(QQBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_QQBtn];
    
    _WeiXinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _WeiXinBtn.frame = CGRectMake((self.view.frame.size.width - 50)/2 - 100, SCREEN_HEIGHT-150, 50, 50);
    _WeiXinBtn.layer.cornerRadius = 25;
    [_WeiXinBtn setBackgroundImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [_WeiXinBtn addTarget:self action:@selector(WeiXinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_WeiXinBtn];
    
    _XinLangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _XinLangBtn.frame = CGRectMake((self.view.frame.size.width - 50)/2 + 100, SCREEN_HEIGHT-150, 50, 50);
    _XinLangBtn.layer.cornerRadius = 25;
    [_XinLangBtn setBackgroundImage:[UIImage imageNamed:@"microblog"] forState:UIControlStateNormal];
    [_XinLangBtn addTarget:self action:@selector(XinLangBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_XinLangBtn];
    }
    
}

-(void)returnLoginBtnsss
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)forgetPasswordClick{
    ForgetPassViewController *forget=[[ForgetPassViewController alloc]init];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *newver = [userDefault objectForKey:@"newver"];
    
    if (IFNEWVER) {
        [self.navigationController wxs_pushViewController:forget animationType:WXSTransitionAnimationTypeBrickOpenHorizontal];
    }else{
        [self.navigationController pushViewController:forget animated:YES];
    }

}
//注册接口
-(void)registAccountInterface
{
    RegisterViewController *regist=[[RegisterViewController alloc]init];
//    [self presentViewController:regist animated:YES completion:nil];
//    [self.navigationController pushViewController:regist animated:YES];
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *newver = [userDefault objectForKey:@"newver"];
    
    if (IFNEWVER) {
        [self.navigationController wxs_pushViewController:regist animationType:WXSTransitionAnimationTypeBrickOpenHorizontal];
    }else{
        [self.navigationController pushViewController:regist animated:YES];
    }

}
//登录方法
-(void)loginAccountButton
{
    

    
    NSString *userName =[FormValidator checkMobile:_phoneTextField.text];
    NSString *passWord=[FormValidator checkPassword:_passwordText.text];
    if ([_phoneTextField.text isEqualToString:@""]||_phoneTextField.text == nil||[_passwordText.text isEqualToString:@""]||_passwordText.text == nil) {
        [FormValidator showAlertWithStr:@"用户名或密码不能为空"];
        return;
    }else{
        if (userName) {
            [FormValidator showAlertWithStr:userName];
            return;
        }
        if (passWord) {
            [FormValidator showAlertWithStr:passWord];
            return;
        }
    }
    [self loginAccountInter];
    
    
}


//登陆接口
-(void)loginAccountInter
{
    [self.view endEditing:YES];

    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"phone"] = [NSString stringWithFormat:@"%@",_phoneTextField.text];
    mDic[@"passwd"] = [NSString stringWithFormat:@"%@",_passwordText.text];
    NSDictionary *dic=@{@"code":@"phoneLogin",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result) {
        NSLog(@"user：%@",result);
         NSDictionary *dic =(NSDictionary *)result;
        if ([result[@"status"] isEqual:@(1)]) {
            //[FormValidator showAlertWithStr:@"登录成功"];
            //用户名密码输入正确后，登录后需要跳转的页面
            //[self HongbaoNotification];//红包信息
            [[NSNotificationCenter defaultCenter]postNotificationName:@"userViewGoto" object:nil userInfo:dic];
            [GJTokenManager saveToken:dic[@"token"]];
            _ret = [[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_LOGN"]boolValue];
            if (_ret==YES) {
                NSLog(@"不是第一次登录");
            }else{
                NSLog(@"第一次登录");
            [GJTokenManager saveUserAccount:_phoneTextField.text];
            [GJTokenManager saveUserPassword:_passwordText.text];
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"USER_LOGN"];
            }
            
        }else if ([result[@"status"] isEqual:@(-1)]) {
            [FormValidator showAlertWithStr:result[@"msg"]];
        }else{
            [FormValidator showAlertWithStr:result[@"msg"]];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"请求错误%@",erro);
        [FormValidator showAlertWithStr:failTipe];
        
    } showHUD:self.view];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_phoneTextField endEditing:YES];
    [_passwordText endEditing:YES];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:@"userViewGoto"];
}
-(UITextField *)addtextFieldWithHeight:(CGFloat)heigh AndImgStr:(NSString *)imgStr AndStr:(NSString *)str
{
    UIImageView *imgBack =[UIImageView addImgWithFrame:CGRectMake(30*Width, heigh*Height, 260*Width, 36*Height) AndImage:@"loginText"];
    [_backView addSubview:imgBack];
    
    UITextField *textF =[UITextField addTextFieldWithFrame:CGRectMake(30*Width, (heigh+0.5)*Height, 260*Width, 35*Height) AndStr:str AndFont:14 AndTextColor:whitesColor];
    [_backView addSubview:textF];
    
    
    return textF;
}
-(void)QQBtnClick
{
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_QQ completion:^(id result, NSError *error) {
    NSLog(@"取消授权%@",result);
    NSLog(@"Auth fail with error %@", error);
    }];
    
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
          if ([result[@"status"] isEqual:@(1)]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userViewGoto" object:nil userInfo:dic];
          }
    } failure:^(NSError *erro) {
        NSLog(@"请求错误%@",erro);
        
    } showHUD:self.view];
    
}

-(void)WeiXinBtnClick
{
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_WechatSession completion:^(id result, NSError *error) {
        NSLog(@"取消授权%@",result);
        NSLog(@"Auth fail with error %@", error);
    }];

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
        
    } showHUD:self.view];
    
}
-(void)XinLangBtnClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新浪微博登陆" message:@"该功能正在开发，给你带来不便请见谅" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton =YES;
    self.navigationItem.title=@"登录";

    if ([GJTokenManager hasAvalibleUserAccount]) {
        NSLog(@"不是第一次登录");
        _phoneTextField.text=[GJTokenManager userAccount];
        _passwordText.text=[GJTokenManager userPassword];
        NSLog(@"_phoneTextField:%@",_phoneTextField.text);
        NSLog(@"_passwordText:%@",_passwordText.text);
        NSLog(@"自动登录");
    }

}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
    
}

@end
