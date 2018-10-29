//
//  ForgetPassWordVCNew.m
//  易林Video
//
//  Created by beijingduanluo on 15/12/19.
//  Copyright © 2015年 beijingduanluo. All rights reserved.
//

#import "ForgetPassViewController.h"

@interface ForgetPassViewController ()
{
    int timeCount;
    NSTimer*timer;
}
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)UIButton *loginBtnReturn;
@property(nonatomic,strong)UIImageView *backImgV;
@property(nonatomic,strong)UIImageView *backView;
@property(nonatomic,strong)UITextField *phoneTextField;
@property(nonatomic,strong)UIImageView *phoneImgV;
@property(nonatomic,strong)UITextField *passwordText;
@property(nonatomic,strong)UIImageView *passwordImgV;
@property(nonatomic,strong)UIButton *loginBtn;

@property(nonatomic,strong)UITextField *yanzhengTextF;
@property(nonatomic,strong)UIButton *huoquBtn;
@property(nonatomic,copy)NSString *registStr;
@end

@implementation ForgetPassViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view=[super view];
    self.title=@"找回密码";
    [self addBarButtonItem];
    _backImgV =[UIImageView addImgWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) AndImage:@"444"];
    [self.view addSubview:_backImgV];
    
//    GJSCRollBACKView *wsRoll = [[GJSCRollBACKView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    wsRoll.backgroundColor = [UIColor whiteColor];
//    wsRoll.timeInterval = 0.05; //移动一次需要的时间
//    wsRoll.rollSpace = 0.5; //每次移动的像素距离
//    wsRoll.direction = RollDirectionLeftRight;//滚动的方向
//    wsRoll.image = [UIImage imageNamed:@"555.jpg"];//本地图片
//    //    wsRoll.rollImageURL = @"http://jiangsu.china.com.cn/uploadfile/2016/0122/1453449251090847.jpg"; //网络图片地址
//    [wsRoll startRoll]; //开始滚动
//    [self.view addSubview:wsRoll];
    
    _backImgV.userInteractionEnabled = YES;
    _backView =[UIImageView addImgWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) AndImage:nil];
    [self.view addSubview:_backView];
    _backView.backgroundColor=[UIColor clearColor];
    _backView.userInteractionEnabled = YES;
    
//    _loginBtnReturn =[UIButton addBtnImage:@"login_Return_Left" AndFrame:CGRectMake(20*Height, 30*Height, 25*Width, 25*Height) WithTarget:self action:@selector(returnLoginBtn)];
//    [_backView addSubview:_loginBtnReturn];
    
    _phoneTextField =[self addtextFieldWithHeight:150 AndImgStr:nil AndStr:@"请输入手机号码"];
    _phoneTextField.keyboardType =UIKeyboardTypeNumberPad;
    [_backView addSubview:_phoneTextField];
    
    _passwordText =[self addtextFieldWithHeight:200 AndImgStr:nil AndStr:@"请输入新的密码"];
    [_backView addSubview:_passwordText];
    
    _loginBtn =[UIButton addBtnImage:@"revise" AndFrame:CGRectMake(30*Width, 300*Height, 260*Width, 36*Height) WithTarget:self action:@selector(passwordButton)];
    [_backView addSubview:_loginBtn];
    
    _phoneTextField.clearButtonMode = UITextFieldViewModeAlways;
    _passwordText.clearButtonMode = UITextFieldViewModeAlways;

    _yanzhengTextF =[self textWithH:250 AndW:140 AndStr:@"输入验证码"];
    _yanzhengTextF.keyboardType =UIKeyboardTypeNumberPad;
    [_backView addSubview:_yanzhengTextF];
    
    
    _huoquBtn =[UIButton addBtnImage:nil AndFrame:CGRectMake(180*Width, 250*Width, 110*Width, 36*Height) WithTarget:self action:@selector(passwordYanZheng)];
    [_huoquBtn setBackgroundImage:[UIImage imageNamed:@"register_huoqu"] forState:UIControlStateNormal];
    
    [_huoquBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_huoquBtn setTitleColor:whitesColor forState:UIControlStateNormal];
    _huoquBtn.titleLabel.font =[UIFont systemFontOfSize:12*Width weight:1];
    [_backView addSubview:_huoquBtn];
    
    //验证提交之后的跑秒提示防止用户的重复提交数据有效时间60秒
    _tipLabel=[[UILabel alloc ]initWithFrame:CGRectMake(180*Width, 250*Height, 110*Width, 35*Height)];
    _tipLabel =[UILabel addLabelWithFrame:CGRectMake(180*Width, 250*Height, 110*Width, 35*Height) AndText:[[NSString alloc]initWithFormat:@"%ds",timeCount] AndFont:14 AndAlpha:1 AndColor:whitesColor];
    _tipLabel.textAlignment=NSTextAlignmentCenter;
    timeCount = 60;
    _tipLabel.layer.cornerRadius=3;
    _tipLabel.clipsToBounds=YES;
    _tipLabel.backgroundColor=[UIColor lightGrayColor];
    _tipLabel.hidden=YES;
    
    [_backView addSubview:_tipLabel];
    _passwordText.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTextField.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTextField.textAlignment=NSTextAlignmentCenter;
    _passwordText.textAlignment=NSTextAlignmentCenter;
    _yanzhengTextF.textAlignment=NSTextAlignmentCenter;

    
}
-(void)addBarButtonItem{
    UIImage* Limage= [UIImage imageNamed:@"liftBtn"];
    CGRect Lframe= CGRectMake(0, 0, 20, 20);
    UIButton *LsomeButton= [[UIButton alloc] initWithFrame:Lframe];
    [LsomeButton addTarget:self action:@selector(Lback) forControlEvents:UIControlEventTouchUpInside];
    [LsomeButton setBackgroundImage:Limage forState:UIControlStateNormal];
    [LsomeButton setShowsTouchWhenHighlighted:YES];
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:LsomeButton];
    
    
}
//返回
- (void)Lback {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark-->读秒开始
-(void)readSecond{
    _huoquBtn.hidden=YES;
    _tipLabel.hidden=NO;
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dealTimer) userInfo:nil repeats:YES];
    timer.fireDate=[NSDate distantPast];
}

#pragma mark-->跑秒操作
-(void)dealTimer{
    _tipLabel.text=[[NSString alloc]initWithFormat:@"%ds",timeCount];
    timeCount=timeCount - 1;
    if(timeCount== 0){
        timer.fireDate=[NSDate distantFuture];
        timeCount= 60;
        _tipLabel.hidden=YES;
        _huoquBtn.hidden=NO;
    }
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



//验证码
-(void)passwordYanZheng
{    [self readSecond];
    if ([_phoneTextField.text isEqualToString:@""]||_phoneTextField.text == nil) {
        [FormValidator showAlertWithStr:@"请输入手机号"];
        
    }else{
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        mDic[@"phone"] = [NSString stringWithFormat:@"%@",_phoneTextField.text];
        mDic[@"type"] = @"pswcode";
        NSDictionary *dic=@{@"code":@"sendcode",@"data":mDic};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        //加密
        NSString *encryptStr=[SecurityUtil dataAESdata:data];
        NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
        
        [CKHttpCommunicate createRequest:HTTP_Home WithParam:jData withMethod:POST success:^(id result) {
             [FormValidator showAlertWithStr:result[@"msg"]];
            NSLog(@"发送成功%@",result);
        
            
        } failure:^(NSError *erro) {
            NSLog(@"请求错误%@",erro);
            [FormValidator showAlertWithStr:[NSString stringWithFormat:@"%@",[erro localizedDescription]]];
            
        } showHUD:self.view];
    }
    
}




//修改密码
-(void)passwordButton
{
    if ([_phoneTextField.text isEqualToString:@""]||_phoneTextField.text == nil||[_passwordText.text isEqualToString:@""]||_passwordText.text == nil) {
        [FormValidator showAlertWithStr:@"用户名或密码不能为空"];
        return;
    }else if([_yanzhengTextF.text length]==6){
    
            [self sureData];
        }else{
            [FormValidator showAlertWithStr:@"验证码输入不正确，请重新输入"];
        }
    
}
-(void)sureData
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"phone"] = [NSString stringWithFormat:@"%@",_phoneTextField.text];
    mDic[@"code"] = [NSString stringWithFormat:@"%@",_yanzhengTextF.text];
    mDic[@"password"] = [NSString stringWithFormat:@"%@",_passwordText.text];
    NSDictionary *dic=@{@"code":@"findpwd",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];

    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jData withMethod:POST success:^(id result) {
        
        NSDictionary *dic =(NSDictionary *)result;
        //        NSLog(@"%@",dic);
        NSDictionary *userDic =[NSDictionary dictionaryWithObjectsAndKeys:_phoneTextField.text,@"phone",_passwordText.text,@"password",[dic objectForKey:@"id"],@"userid",[dic objectForKey:@"name"],@"name", nil];
        
        [SHInvoker  saveUserInfo:userDic];
        if ([result[@"status"] intValue]==1) {
            [FormValidator showAlertWithStr:result[@"msg"]];
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"USER_LOGN"];
            [GJTokenManager removelibleUserPassword];
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            [FormValidator showAlertWithStr:result[@"msg"]];
            
 
        }
        //[self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *erro) {
        NSLog(@"请求错误%@",erro);
        [FormValidator showAlertWithStr:[NSString stringWithFormat:@"%@",[erro localizedDescription]]];
        
    } showHUD:self.view];
    
}





-(UITextField *)addtextFieldWithHeight:(CGFloat)heigh AndImgStr:(NSString *)imgStr AndStr:(NSString *)str
{
    UIImageView *imgBack =[UIImageView addImgWithFrame:CGRectMake(30*Width, heigh*Height, 260*Width, 36*Height) AndImage:@"regiser"];
    [_backView addSubview:imgBack];
    
    UITextField *textF=[UITextField addTextFieldWithFrame:CGRectMake(30*Width, (heigh+0.5)*Height, 260*Width, 35*Height) AndStr:str AndFont:14 AndTextColor:whitesColor];
    [_backView addSubview:textF];
    
    
    return textF;
}
-(UITextField *)textWithH:(CGFloat)heigh AndW:(CGFloat)Widh AndStr:(NSString *)str
{
    UIImageView *imgBack =[UIImageView addImgWithFrame:CGRectMake(30*Width, heigh*Height, Widh*Width, 36*Height) AndImage:@"regiser"];
    [_backView addSubview:imgBack];
    UITextField *textF=[UITextField addTextFieldWithFrame:CGRectMake(30*Width, (heigh+0.5)*Height, Widh*Width, 35*Height) AndStr:str AndFont:14 AndTextColor:whitesColor];
    
    return textF;
    
}

//-(void)returnLoginBtn
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}


@end
