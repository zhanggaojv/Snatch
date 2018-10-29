//
//  PhoneViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/6.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "PhoneViewController.h"

@interface PhoneViewController ()
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
//@property(nonatomic,strong)UITextField *passwordText;
@property(nonatomic,strong)UIImageView *passwordImgV;
@property(nonatomic,strong)UIButton *loginBtn;

@property(nonatomic,strong)UITextField *yanzhengTextF;
@property(nonatomic,strong)UIButton *huoquBtn;
@property(nonatomic,copy)NSString *registStr;
@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"绑定手机号";
    [self addBarButtonItem];
    [self addUI];
    
}
-(void)addBarButtonItem{
    UIImage* Limage= [UIImage imageNamed:@"liftBtn"];
    CGRect Lframe= CGRectMake(0, 0, 20, 20);
    UIButton *LsomeButton= [[UIButton alloc] initWithFrame:Lframe];
    [LsomeButton addTarget:self action:@selector(Lback) forControlEvents:UIControlEventTouchUpInside];
    [LsomeButton setBackgroundImage:Limage forState:UIControlStateNormal];
    [LsomeButton setShowsTouchWhenHighlighted:YES];
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:LsomeButton];
    
    UIImage* Rimage= [UIImage imageNamed:@"rightBtn"];
    CGRect Rframe= CGRectMake(0, 0, 20, 20);
    UIButton *RsomeButton= [[UIButton alloc] initWithFrame:Rframe];
    [RsomeButton addTarget:self action:@selector(Rback) forControlEvents:UIControlEventTouchUpInside];
    [RsomeButton setBackgroundImage:Rimage forState:UIControlStateNormal];
    [RsomeButton setShowsTouchWhenHighlighted:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RsomeButton];
    
}
//返回
- (void)Lback {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)Rback {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)addUI{
    self.view=[super view];
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
    
    
    _phoneTextField =[self addtextFieldWithHeight:150 AndImgStr:nil AndStr:@"请输入手机号码"];
    _phoneTextField.keyboardType =UIKeyboardTypeNumberPad;
    [_backView addSubview:_phoneTextField];
    
    _loginBtn =[UIButton addBtnImage:@"bangding" AndFrame:CGRectMake(30*Width, 300*Height, 260*Width, 36*Height) WithTarget:self action:@selector(bindAccountButton)];
    [_backView addSubview:_loginBtn];
    
    _yanzhengTextF =[self textWithH:200 AndW:140 AndStr:@"输入验证码"];
    _yanzhengTextF.keyboardType =UIKeyboardTypeNumberPad;
    [_backView addSubview:_yanzhengTextF];
    
    
    _huoquBtn =[UIButton addBtnImage:nil AndFrame:CGRectMake(180*Width, 200*Width, 110*Width, 36*Height) WithTarget:self action:@selector(bindYanZheng)];
    [_huoquBtn setBackgroundImage:[UIImage imageNamed:@"register_huoqu"] forState:UIControlStateNormal];
    [_huoquBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_huoquBtn setTitleColor:whitesColor forState:UIControlStateNormal];
    _huoquBtn.titleLabel.font =[UIFont systemFontOfSize:12*Width weight:1];
    [_backView addSubview:_huoquBtn];
    
    //验证提交之后的跑秒提示防止用户的重复提交数据有效时间60秒
    timeCount = 60;
    _tipLabel=[[UILabel alloc ]initWithFrame:CGRectMake(180*Width, 200*Height, 110*Width, 35*Height)];
    _tipLabel.textAlignment=NSTextAlignmentCenter;
    _tipLabel.text=[[NSString alloc]initWithFormat:@"%ds",timeCount];
    _tipLabel.textColor=[UIColor whiteColor];
    _tipLabel.layer.cornerRadius=3;
    _tipLabel.clipsToBounds=YES;
    _tipLabel.backgroundColor=[UIColor lightGrayColor];
    _tipLabel.hidden=YES;
    _tipLabel.font=[UIFont systemFontOfSize:14];
    [_backView addSubview:_tipLabel];
    
    
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
    [_yanzhengTextF endEditing:YES];
    
}





//验证码(绑定手机)
-(void)bindYanZheng
{   [self readSecond];
    if ([_phoneTextField.text isEqualToString:@""]||_phoneTextField.text == nil) {
        [FormValidator showAlertWithStr:@"请输入手机号"];
        
    }else{
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        mDic[@"phone"] = [NSString stringWithFormat:@"%@",_phoneTextField.text];
        mDic[@"type"] = @"bindcode";
        NSDictionary *dic=@{@"code":@"sendcode",@"data":mDic};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        //加密
        NSString *encryptStr=[SecurityUtil dataAESdata:data];
        NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
        
        [CKHttpCommunicate createRequest:HTTP_Home WithParam:jData withMethod:POST success:^(id result) {
            if ([result[@"status"] intValue]==0) {
         [FormValidator showAlertWithStr:result[@"msg"]];
            }else{
                [FormValidator showAlertWithStr:result[@"msg"]];
            }
        
   
            NSLog(@"发送成功%@",result);
            
        } failure:^(NSError *erro) {
            NSLog(@"请求错误%@",erro);
           [FormValidator showAlertWithStr:[NSString stringWithFormat:@"%@",[erro localizedDescription]]];
        } showHUD:self.view];
        
    }
    
}

//用户绑定信息
-(void)bindAccountButton
{
    if ([_phoneTextField.text isEqualToString:@""]||_phoneTextField.text ==nil || [_yanzhengTextF.text isEqualToString:@""]||_yanzhengTextF.text == nil) {
        [FormValidator showAlertWithStr:@"手机号、昵称或者密码不能为空"];
        return;
    }else if([_yanzhengTextF.text length]==6){
            
            [self bindAccountInterface];
        }else{
            [FormValidator showAlertWithStr:@"验证码输入不正确，请重新输入"];
        }
    
}
//绑定接口
-(void)bindAccountInterface
{
    if ([GJTokenManager hasAvalibleToken]) {
        self.token=[GJTokenManager accessToken];
        NSLog(@"––––––––––––%@",self.token);
    }
    
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"phone"] = [NSString stringWithFormat:@"%@",_phoneTextField.text];
    //    mDic[@"protocol"] = @"1";
    //   mDic[@"uid"] = @"";
    mDic[@"code"] =[NSString stringWithFormat:@"%@",_yanzhengTextF.text];
    
    NSDictionary *dic=@{@"code":@"bindphone",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jData withMethod:POST success:^(id result) {
        NSLog(@"_______+++++_______%@",result);
        //        NSDictionary *dic =(NSDictionary *)result;
        //        NSLog(@"%@",dic);
        if ([result[@"status"] isEqual:@(1)]) {
            [FormValidator showAlertWithStr:result[@"msg"]];
            
        }else{
            [FormValidator showAlertWithStr:result[@"msg"]];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_phoneTextField endEditing:YES];
    [_yanzhengTextF endEditing:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
