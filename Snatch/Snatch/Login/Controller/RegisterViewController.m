//
//  RegisterVCNew.m
//  易林Video
//
//  Created by beijingduanluo on 15/12/19.
//  Copyright © 2015年 beijingduanluo. All rights reserved.
//

#import "RegisterViewController.h"
#import "GuanyuViewController.h"
@interface RegisterViewController ()
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
@property(nonatomic,strong)UITextField *inviteCode;
@property(nonatomic,strong)UIImageView *passwordImgV;
@property(nonatomic,strong)UIButton *loginBtn;

@property(nonatomic,strong)UITextField *yanzhengTextF;
@property(nonatomic,strong)UIButton *huoquBtn;
@property(nonatomic,copy)NSString *registStr;

@property (nonatomic,strong) UIButton *checkbox;
@property (nonatomic)  BOOL click;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view=[super view];
    self.title=@"注册";
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
    _backView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_backView];
    _backView.userInteractionEnabled = YES;
    
    _loginBtnReturn =[UIButton addBtnImage:@"" AndFrame:CGRectMake(20*Height, 30*Height, 25*Width, 25*Height) WithTarget:self action:@selector(returnLoginBtn)];
    [_backView addSubview:_loginBtnReturn];
 
    
    _phoneTextField =[self addtextFieldWithHeight:150 AndImgStr:nil AndStr:@"请输入手机号码"];
    _phoneTextField.keyboardType =UIKeyboardTypeNumberPad;
    [_backView addSubview:_phoneTextField];
    
    _passwordText =[self addtextFieldWithHeight:200 AndImgStr:nil AndStr:@"请输入密码"];
    [_backView addSubview:_passwordText];
    
    _inviteCode =[self addtextFieldWithHeight:250 AndImgStr:nil AndStr:@"请输入邀请码（没有可不填）"];
    _inviteCode.keyboardType =UIKeyboardTypeNumberPad;
    [_backView addSubview:_inviteCode];
    
    
    
    _checkbox=[[UIButton alloc]initWithFrame:CGRectZero];
    _checkbox.frame=CGRectMake(30*Width, 350*Height,15, 15);
    //设置点击选中状态图片为check_on.png
    [_checkbox setImage:[UIImage imageNamed:@"paySelected"]forState:UIControlStateNormal];
    [_checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
     //设置按钮得状态是否为选中（可在此根据具体情况来设置按钮得初始状态）
    [_checkbox setSelected:YES];
    [_backView addSubview:_checkbox];
    _click=YES;
   
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(30*Width+12, 350*Height, 210, 15)];
    NSString *string=@" 同意夺你所爱《用户服务协议》  ";
    NSString *name = [string subStringFrom:@" " to:@"《"];
    NSString *text= [string subStringFrom:@"爱" to:@"  "];
    
    NSRange rangeB = [string rangeOfString:[NSString stringWithFormat:@"%@",name]];
    NSRange rangeD = [string rangeOfString:[NSString stringWithFormat:@"%@",text]];
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:string];
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeB];
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor fireBrick] range:rangeD];
    [btn setAttributedTitle:aStr  forState:UIControlStateNormal];
    
    btn.titleLabel.font =[UIFont systemFontOfSize:11*Width];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:btn];
    
    _loginBtn =[UIButton addBtnImage:@"regiserBtn" AndFrame:CGRectMake(30*Width, 400*Height, 260*Width, 36*Height) WithTarget:self action:@selector(registAccountButton)];
    [_backView addSubview:_loginBtn];
    
    _yanzhengTextF =[self textWithH:300 AndW:140 AndStr:@"输入验证码"];
    _yanzhengTextF.keyboardType =UIKeyboardTypeNumberPad;
    [_backView addSubview:_yanzhengTextF];
    
    
    _huoquBtn =[UIButton addBtnImage:nil AndFrame:CGRectMake(180*Width, 300*Width, 110*Width, 36*Height) WithTarget:self action:@selector(registYanZheng)];
    [_huoquBtn setBackgroundImage:[UIImage imageNamed:@"register_huoqu"] forState:UIControlStateNormal];
    [_huoquBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_huoquBtn setTitleColor:whitesColor forState:UIControlStateNormal];
    _huoquBtn.titleLabel.font =[UIFont systemFontOfSize:12*Width weight:1];
    [_backView addSubview:_huoquBtn];
    
    //验证提交之后的跑秒提示防止用户的重复提交数据有效时间60秒
    timeCount = 60;
    _tipLabel=[[UILabel alloc ]initWithFrame:CGRectMake(180*Width, 250*Height, 110*Width, 35*Height)];
    _tipLabel.textAlignment=NSTextAlignmentCenter;
    _tipLabel.text=[[NSString alloc]initWithFormat:@"%ds",timeCount];
    _tipLabel.textColor=[UIColor whiteColor];
    _tipLabel.layer.cornerRadius=3;
    _tipLabel.clipsToBounds=YES;
    _tipLabel.backgroundColor=[UIColor lightGrayColor];
    _tipLabel.hidden=YES;
    _tipLabel.font=[UIFont systemFontOfSize:14];
    [_backView addSubview:_tipLabel];
    
    _passwordText.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTextField.clearButtonMode = UITextFieldViewModeAlways;
    _inviteCode.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTextField.textAlignment=NSTextAlignmentCenter;
    _passwordText.textAlignment=NSTextAlignmentCenter;
    _inviteCode.textAlignment=NSTextAlignmentCenter;
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

//实现checkboxClick方法
-(void)checkboxClick:(UIButton*)btn{
    
    btn.selected=!btn.selected;//每次点击都改变按钮的状态
    
    if(btn.selected){
        [_checkbox setImage:[UIImage imageNamed:@"paySelected"]forState:UIControlStateNormal];
        _click=YES;
        //在此实现打勾时的方法
        NSLog(@"同意");
    }else{
        //在此实现不打勾时的方法
        NSLog(@"不同意");
        _click=NO;
        //设置正常时图片为    check_off.png
        [_checkbox setImage:[UIImage imageNamed:@"payDefault"]forState:UIControlStateNormal];
    }
    
}
-(void)btnAction{
    self.hidesBottomBarWhenPushed=YES;
    GuanyuViewController *xieyi=[[GuanyuViewController alloc]init];
    xieyi.userUrl=@"/news/more/id/2";
    [self.navigationController pushViewController:xieyi animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    NSLog(@"用户协议");
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
    [_phoneTextField endEditing:YES];
    [_passwordText endEditing:YES];
    [_yanzhengTextF endEditing:YES];
    
}





//验证码
-(void)registYanZheng
{  [self readSecond];
    if ([_phoneTextField.text isEqualToString:@""]||_phoneTextField.text == nil) {
        [FormValidator showAlertWithStr:@"请输入手机号"];
        
    }else{
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        mDic[@"phone"] = [NSString stringWithFormat:@"%@",_phoneTextField.text];
        mDic[@"type"] = @"reg";
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
            
        } showHUD:nil];
     
    }
    
}




//用户注册
-(void)registAccountButton
{
    if ([_phoneTextField.text isEqualToString:@""]||_phoneTextField.text ==nil ||[_passwordText.text isEqualToString:@""]||_passwordText.text == nil|| [_yanzhengTextF.text isEqualToString:@""]||_yanzhengTextF.text == nil) {
        [FormValidator showAlertWithStr:@"手机号、昵称或者密码不能为空"];
        return;
    }else if(_passwordText.text.length <6 ){
        [FormValidator showAlertWithStr:@"密码必须6位以上"];
    }else if(_click==NO ){
        [FormValidator showAlertWithStr:@"必须同意服务协议才能注册"];
    }else{
        [self registAccountInterface];
    }
    
}
//注册接口
-(void)registAccountInterface
{
//    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"phone"] = [NSString stringWithFormat:@"%@",_phoneTextField.text];
    mDic[@"passwd"] = [NSString stringWithFormat:@"%@",_passwordText.text];
    mDic[@"protocol"] = @"1";
    if ([_inviteCode.text length]>3) {
      mDic[@"inviteCode"] = [NSString stringWithFormat:@"%@",_inviteCode.text];
    }else{
      mDic[@"inviteCode"] =@"";
    }
   
    mDic[@"code"] =_yanzhengTextF.text;
    
    NSDictionary *dic=@{@"code":@"register",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jData withMethod:POST success:^(id result) {
        NSLog(@"_______+++++_______%@",result);
        //        NSDictionary *dic =(NSDictionary *)result;
        //        NSLog(@"%@",dic);
        if ([result[@"status"] isEqual:@(1)]) {
            [FormValidator showAlertWithStr:result[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [FormValidator showAlertWithStr:result[@"msg"]];
        }
       // [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSError *erro) {
        NSLog(@"请求错误%@",erro);
        [FormValidator showAlertWithStr:@"网路开小差了，请稍后尝试"];
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

-(void)returnLoginBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [UINavigationBar appearance].barTintColor=kDefaultColor;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_phoneTextField endEditing:YES];
    [_passwordText endEditing:YES];
    [_yanzhengTextF endEditing:YES];
    //self.navigationController.navigationBarHidden = YES;

}
//setprepareClipPlayback

@end
