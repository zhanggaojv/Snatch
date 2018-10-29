//
//  BalanceViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/7.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "BalanceViewController.h"
#import "MBProgressHUD+MJ.h"
#import "GJButton.h"

#import "JSONStrToDict.h"
#import "WXApiRequestHandler.h"

#import "UserViewController.h"
#import "SPayClient.h"

#import "QJPaySDK.h"
#import "SignFile.h"

#import "JDPayViewController.h"

#define appId @"0000000353"
#define app_Key @"90d863b49766969f044a5349918d5e39"

#define ABColor(R, G, B, Alpha) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(Alpha)]
#define LINECOLOR [UIColor colorWithWhite:0.8 alpha:0.5]
#define ABButtonMargin 10.0

@interface BalanceViewController ()<UITextFieldDelegate,WXApiDelegate,UIGestureRecognizerDelegate,QJPayManagerDelegate>
{
    NSMutableArray *arr;
    NSInteger btnTag;
    
    //初始化的参数值
    NSArray * disArray;
    
    //初始化的参数值
    NSArray * typeArray;
    //手动参数
    NSMutableDictionary * _handleDic;
    SignFile * _sign_verify_;
    
}

@end

@implementation BalanceViewController

- (void)viewDidLoad {
    self.title=@"充值";
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    arr = [NSMutableArray array];
    [self addBarButtonItem];
    [self setupPhoneNumView];
    _select=2;
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

#pragma mark -- 初始化方法

- (void)setupPhoneNumView {
    
    UILabel *guishudiL = [UILabel new];
    guishudiL.text = @"充值获得夺宝币（1元=1夺宝币），可用于夺宝，充值的宽细无法退回。";
    guishudiL.numberOfLines=2;
    guishudiL.textColor = [UIColor lightGrayColor];
    guishudiL.font = [UIFont systemFontOfSize:13];
    guishudiL.frame = CGRectMake(20, 64, (self.view.width-40), 80);
    [self.view addSubview:guishudiL];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = LINECOLOR;
    lineView.frame = CGRectMake(20, CGRectGetMaxY(guishudiL.frame)+10, SCREEN_WIDTH-40, 1);
    [self.view addSubview:lineView];
    
    _moneyWay=[[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(lineView.frame)+2, 130, 20)];
    _moneyWay.text=@"选择充值金额（元）";
    _moneyWay.textColor = [UIColor lightGrayColor];
    _moneyWay.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_moneyWay];
    
    
    
    // 创建按钮
    [self setupBtn];
}
- (void)setupBtn {
    _btnArr=[NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        GJButton *abBtn = [[GJButton alloc] init];
        abBtn.tag = 100+i;
        switch (i) {
            case 0:
            {
                [abBtn buttonWithAboveLabelTitle:@"10" belowLabelTitle:nil];
                //abBtn.enabled = NO;
            }
                break;
            case 1:
            {
                [abBtn buttonWithAboveLabelTitle:@"20" belowLabelTitle:nil];
            }
                break;
            case 2:
            {
                [abBtn buttonWithAboveLabelTitle:@"50" belowLabelTitle:nil];
            }
                break;
            case 3:
            {
                [abBtn buttonWithAboveLabelTitle:@"100" belowLabelTitle:nil];
            }
                break;
                
            case 4:
            {
                [abBtn buttonWithAboveLabelTitle:@"200" belowLabelTitle:nil];
            }
                break;
            case 5:
            {
                [abBtn buttonWithAboveLabelTitle:@"" belowLabelTitle:nil];
                [self otherMoney:abBtn];
            }
                break;
                
            default:
                break;
        }
        
        int col = i % 3;
        abBtn.x = col * (abBtn.width + ABButtonMargin)+20;
        int row = i / 3;
        abBtn.y = row * (abBtn.height + ABButtonMargin)+180;
        [self.view addSubview:abBtn];
        [abBtn addTarget:self action:@selector(chargePhone:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArr addObject:abBtn];
    }
    
    _playWay=[[UILabel alloc]initWithFrame:CGRectMake(20, 300, 130, 20)];
    _playWay.text=@"选择支付方式";
    _playWay.textColor = [UIColor lightGrayColor];
    _playWay.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_playWay];
    
//    _way=[[UIImageView alloc]initWithFrame:CGRectMake(20, 340, 15, 15)];
//    _way.image=[UIImage imageNamed:@"paySelected"];
//    [self.view addSubview:_way];
//    
//    _WXPlay=[[UILabel alloc]initWithFrame:CGRectMake(20+20, 340, 70, 15)];
//    _WXPlay.text=@"微信支付";
//    _WXPlay.textColor=ABColor(177, 179, 182, 1.0);
//    _WXPlay.font = [UIFont systemFontOfSize:13];
//    [self.view addSubview:_WXPlay];
    
    UIView *playView=[[UIView alloc]initWithFrame:CGRectMake(0, 329, SCREEN_WIDTH, SCREEN_HEIGHT-329)];
    playView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:playView];
    int high=60;

    UIView *Wv=[[UIView alloc]initWithFrame:CGRectMake(0, 0*(high+1)+1, SCREEN_WIDTH, high)];
    Wv.backgroundColor=[UIColor whiteColor];
    [playView addSubview:Wv];
    _WXPay=[[UIButton alloc]initWithFrame:CGRectMake(10, (high-15)/2 , 15, 15)];
    [_WXPay setImage:[UIImage imageNamed:@"paySelected"] forState:UIControlStateNormal];
    
    [_WXPay addTarget:self action:@selector(WXPayAction) forControlEvents:UIControlEventTouchUpInside];
    [Wv addSubview:_WXPay];
    
    UIImageView *wImage=[[UIImageView alloc]initWithFrame:CGRectMake(10+25,(high-25)/2, 25, 25)];
    wImage.image=[UIImage imageNamed:@"wxpay"];
    [Wv addSubview:wImage];
    
    _Wlabel=[[UILabel alloc]initWithFrame:CGRectMake(10+25+30,(high-30)/2, 70, 30)];
    _Wlabel.text=[NSString stringWithFormat:@"微信支付"];
    _Wlabel.font=[UIFont systemFontOfSize:13];
    _Wlabel.textColor=[UIColor blackColor];
    [Wv addSubview:_Wlabel];
    
    Wv.userInteractionEnabled = YES;
    UITapGestureRecognizer * wvTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WXPayAction)];
    wvTap.numberOfTouchesRequired = 1; //手指数
    wvTap.numberOfTapsRequired = 1; //tap次数
    wvTap.delegate= self;
    [Wv addGestureRecognizer:wvTap];
    
    UIView *Zv=[[UIView alloc]initWithFrame:CGRectMake(0, 1*(high+2), SCREEN_WIDTH, high)];
     Zv.backgroundColor=[UIColor whiteColor];
    [playView addSubview:Zv];
    _ZPay=[[UIButton alloc]initWithFrame:CGRectMake(10, (high-15)/2 , 15, 15)];
    [_ZPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
    
    [_ZPay addTarget:self action:@selector(ZPayAction) forControlEvents:UIControlEventTouchUpInside];
    [Zv addSubview:_ZPay];
    
    UIImageView *ZImage=[[UIImageView alloc]initWithFrame:CGRectMake(10+25,(high-25)/2, 25, 25)];
    ZImage.image=[UIImage imageNamed:@"jdpay"];
    [Zv addSubview:ZImage];
    
    _Zlabel=[[UILabel alloc]initWithFrame:CGRectMake(10+25+30,(high-30)/2, 70, 30)];
    _Zlabel.text=[NSString stringWithFormat:@"京东支付"];
    _Zlabel.font=[UIFont systemFontOfSize:13];
    _Zlabel.textColor=[UIColor blackColor];
    [Zv addSubview:_Zlabel];
    
    Zv.userInteractionEnabled = YES;
    UITapGestureRecognizer * ZvTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ZPayAction)];
    ZvTap.numberOfTouchesRequired = 1; //手指数
    ZvTap.numberOfTapsRequired = 1; //tap次数
    ZvTap.delegate= self;
    [Zv addGestureRecognizer:ZvTap];


    

    UIView *czView=[[UIView alloc]initWithFrame:CGRectMake(0,Zv.bottom+1, SCREEN_WIDTH, SCREEN_HEIGHT-Zv.bottom)];
    czView.backgroundColor=[UIColor whiteColor];
    [playView addSubview:czView];
    
    UIButton *play=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2,(high-20)/2, 200, 40)];
    [play setTitle:@"立即充值" forState:UIControlStateNormal];
    play.titleLabel.textColor=[UIColor whiteColor];
    play.titleLabel.font=SYSTEM_FONT(14);
    play.layer.masksToBounds=YES;
    play.layer.cornerRadius=4;
    play.layer.rasterizationScale =kScreenScale;
    play.backgroundColor=[UIColor redColor];
    [play addTarget:self action:@selector(czPlayAction) forControlEvents:UIControlEventTouchUpInside];
    [czView addSubview:play];
}
-(void)otherMoney:(UIButton *)abBtn{
    _money = [UITextField new];
    _money.delegate = self;
    _money.text = @"";
    [_money setTextAlignment:NSTextAlignmentCenter];
    _money.placeholder = @"其他金额";
    [_money setValue:[UIColor lightSeaGreen]
          forKeyPath:@"_placeholderLabel.textColor"];
    _money.keyboardType = UIKeyboardTypePhonePad;
    _money.backgroundColor=[UIColor whiteColor];
    _money.textColor = [UIColor lightSeaGreen];
    _money.font = [UIFont systemFontOfSize:18.0];
    _money.frame = CGRectMake(0, 0, abBtn.width, abBtn.height);
    [abBtn addSubview:_money];
    
}


#pragma mark -- 点击方法
-(void)backBtn{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)chargePhone:(GJButton*)sender{
    [_money resignFirstResponder];
    if (sender!= self.selBtn) {
        
        self.selBtn.selected = NO;
        sender.selected = YES;
        self.selBtn = sender;
    }else{
        self.selBtn.selected = YES;
    }
    _money.text=nil;
    _money.placeholder = @"其他金额";
    NSLog(@"充值%@", sender.aboveL.text);
    _pay=sender.aboveL.text;
}

-(void)WXPayAction{
    _select=2;
    [_WXPay setImage:[UIImage imageNamed:@"paySelected"] forState:UIControlStateNormal];
    [_ZPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
}
-(void)ZPayAction{
    _select=3;
    [_WXPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
    [_ZPay setImage:[UIImage imageNamed:@"paySelected"] forState:UIControlStateNormal];

}

-(void)czPlayAction{
    [_money resignFirstResponder];
    if (_selBtn.selected==YES) {
        NSLog(@"__%@",_pay);
    }else{
        _pay=_money.text;
        NSLog(@"__%@",_pay);
    }
//    [self playwxApp];
    //[self payApp];
    
    if ([_pay intValue]==0) {
    [FormValidator showAlertWithStr:@"请选择充值金额"];
    }else if(_select==2){
//    [self goWXplay];
        [self payApp];
    }else if(_select==3){
        [self JDpaly];
    }
}
-(void)JDpaly{
    
    self.hidesBottomBarWhenPushed=YES;
    JDPayViewController *jd=[[JDPayViewController alloc]init];
    jd.price=_pay;
    jd.pid=[NSString stringWithFormat:@"%d",0];
    jd.queue=[NSString stringWithFormat:@"%d",1];
    
    NSLog(@"price=%@  pid=%@ queue=%@",jd.price,jd.pid,jd.queue);
    [self.navigationController pushViewController:jd animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

-(void)goWXplay{
    if (_sign_verify_==nil) {
        _sign_verify_ = [[SignFile alloc] init];
        
    }
    NSString *randomString = [NSString stringWithFormat:@"%d",(int)(100000 + (arc4random() % (900001)))];
    int p=[_pay intValue];
    NSString *pice=[NSString stringWithFormat:@"%d",p*100];
    NSString *title=[NSString stringWithFormat:@"夺宝币"];
    disArray = @[@"订单金额:",@"appId:",@"商品描述:",@"客户端Ip:",@"商户订单号:",@"商品标题:"];
    typeArray = @[pice,appId,@"非数字型商品",@"192.168.1.117",randomString,title,@"支付方式"];
    
    
    _handleDic = [NSMutableDictionary dictionaryWithObjects:@[typeArray[0],typeArray[1],typeArray[2],typeArray[3],randomString,typeArray[5],[QJPaySDK PAY_WEIXIN],@"ios_v1_1_5"] forKeys:@[@"amount",@"appid",@"body",@"clientIp",@"mchntOrderNo",@"subject",@"payChannelId",@"version"]];
    
    [QJPaySDK QJPayStart:_handleDic AppScheme:@"QJPaySDKGUI" appKey:app_Key  andCurrentViewController:self andDelegate:self Flag:0x80];
}
-(void)goZFBPaly{
    if (_sign_verify_==nil) {
        _sign_verify_ = [[SignFile alloc] init];
        
    }
    NSString *randomString = [NSString stringWithFormat:@"%d",(int)(100000 + (arc4random() % (900001)))];
    int p=[_pay intValue];
    NSString *pice=[NSString stringWithFormat:@"%d",p*1];
    NSString *title=[NSString stringWithFormat:@"夺宝币"];
    disArray = @[@"订单金额:",@"appId:",@"商品描述:",@"客户端Ip:",@"商户订单号:",@"商品标题:"];
    typeArray = @[pice,appId,@"非数字型商品",@"192.168.1.117",randomString,title,@"支付方式"];
    
    
    _handleDic = [NSMutableDictionary dictionaryWithObjects:@[typeArray[0],typeArray[1],typeArray[2],typeArray[3],randomString,typeArray[5],[QJPaySDK PAY_APLIPAY],@"ios_v1_1_5"] forKeys:@[@"amount",@"appid",@"body",@"clientIp",@"mchntOrderNo",@"subject",@"payChannelId",@"version"]];
    
    [QJPaySDK QJPayStart:_handleDic AppScheme:@"QJPaySDKGUI" appKey:app_Key  andCurrentViewController:self andDelegate:self Flag:0x80];
    
    
}
- (void)QJPayResponseResult:(int)response
{
    NSLog(@"结果结果  %d",response);
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置显示的颜色
    bar.barTintColor = [UIColor redColor];
    NSLog(@"结果：");
    NSString* result=@"结果：";
    
    
    
    switch (response) {
        case 0:
            NSLog(@"成功＝＝＝＝＝＝＝＝＝＝＝＝＝");
            result=@"成功";
            break;
        case 1:
            NSLog(@"取消＝＝＝＝＝＝＝＝＝＝＝＝＝");
            result=@"取消";
            //           [self.navigationController popViewControllerAnimated:YES];
            break;
        case -1:
            NSLog(@"失败＝＝＝＝＝＝＝＝＝＝＝＝＝");
            result=@"失败";
            
            break;
            
            
        default:
            break;
    }
    //    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"回调提示" message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //    [alert show];
}


-(void)payApp{
    _wxData=[NSMutableDictionary dictionary];
    self.token=[GJTokenManager accessToken];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    NSString *pid=[NSString stringWithFormat:@"%d",0];
    //NSString *queue=[NSString stringWithFormat:@"%d",1];
    mDic[@"price"] = _pay;
    mDic[@"pid"] = pid;
    //mDic[@"queue"] = queue;
    NSDictionary *dic=@{@"code":@"playwxapp",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jData withMethod:POST success:^(id result) {
        NSLog(@"55%@",result);
        _wxData=result[@"data"];
        [self SPay:_wxData];
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:self.view];
    
    
}

-(void)SPay:(NSMutableDictionary *)wxData{
    // 调起SPaySDK支付
    [[SPayClient sharedInstance] pay:self
                              amount:_wxData[@"key"]
                   spayTokenIDString:_wxData[@"token_id"]
                   payServicesString:@"pay.weixin.app"
                              finish:^(SPayClientPayStateModel *payStateModel,
                                       SPayClientPaySuccessDetailModel *paySuccessDetailModel) {
                                  
                                  //更新订单号
                                  //self.out_trade_noText.text = _wxData[@"sign"];
                                  
                                  
                                  if (payStateModel.payState == SPayClientConstEnumPaySuccess) {
                                      
                                      NSLog(@"支付成功");
                                      NSLog(@"支付订单详情-->>\n%@",[paySuccessDetailModel description]);
                                  }else{
                                      NSLog(@"支付失败，错误号:%d",payStateModel.payState);
                                  }
                                  
                              }];
    
}

-(void)playwxApp{
    _wxData=[NSMutableDictionary dictionary];
    self.token=[GJTokenManager accessToken];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    NSString *pid=[NSString stringWithFormat:@"%d",0];
    //NSString *queue=[NSString stringWithFormat:@"%d",1];
    mDic[@"price"] = _pay;
    mDic[@"pid"] = pid;
    //mDic[@"queue"] = queue;
    NSDictionary *dic=@{@"code":@"playwxapp",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jData withMethod:POST success:^(id result) {
        NSLog(@"55%@",result);
        _wxData=result[@"data"];
        [self bizPay:_wxData];
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:self.view];
    
    
}

- (void)bizPay:(NSMutableDictionary *)dict {
    NSString *res = [WXApiRequestHandler jumpToBizPay:dict];
    
    //引发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName" object:nil];
    
    UserViewController *user=[[UserViewController alloc]init];
    [self.navigationController pushViewController:user animated:YES];
    if( ![@"" isEqual:res] ){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }
    
}

+ (NSString *)jumpToBizPay:(NSMutableDictionary *)dict {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2016年7月20日
    //============================================================
    //    NSString *urlString   = ;
    //    //解析服务端返回json数据
    //    NSError *error;
    //    //加载一个NSURL对象
    //    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //    //将请求的url数据放到NSData对象中
    //    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    if ( response != nil) {
    //        NSMutableDictionary *dict = NULL;
    //        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    //        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //
    //        NSLog(@"url:%@",urlString);
    if(dict != nil){
        NSMutableString *retcode = [dict objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
             [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoUSerView" object:nil userInfo:nil];
             [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoUSer) name:@"gotoUSerView" object:nil];
            return @"充值成功";
           
        }else{
            return [dict objectForKey:@"retmsg"];
        }
    }else{
        return @"服务器返回错误，未获取到json对象";
    }
    //    }else{
    //        return @"服务器返回错误";
    //    }
   
}
-(void)gotoUSer{
    UserViewController *user=[[UserViewController alloc]init];
    
    [self.navigationController pushViewController:user animated:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _selBtn.selected=NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
