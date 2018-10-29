//
//  PayViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/14.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "PayViewController.h"
#import "JSONStrToDict.h"
#import "WXApiRequestHandler.h"
#import "PhoneViewController.h"
#import "SPayClient.h"
#import "JDPayViewController.h"
#import "RedEnvelopeViewController.h"

#import "QJPaySDK.h"
#import "SignFile.h"
//#define appId @"0000000022"
//#define app_Key @"e7d4c31780d1379c6af38f82e455967c"
#define appId @"0000000353"
#define app_Key @"90d863b49766969f044a5349918d5e39"


@interface PayViewController ()<WXApiDelegate,UIGestureRecognizerDelegate,QJPayManagerDelegate,DeliverDetegate,hbidDetegate>
{
    //初始化的参数值
    NSArray * disArray;
    
    //初始化的参数值
    NSArray * typeArray;
    //手动参数
    NSMutableDictionary * _handleDic;
    
}

@end

@implementation PayViewController{
    SignFile * _sign_verify_;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self sendHttpRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.title=@"支付订单";
    //[self sendHttpRequest];
    [self addBarButtonItem];
     //[self addPayUI];
    _select=1;
    
    
}
- (void)sendHttpRequest{
    _data=[NSMutableDictionary dictionary];
    if (_number==nil) {
        _number=[NSString stringWithFormat:@"%d",1];
    }
    self.token=[GJTokenManager accessToken];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"pid"] = [NSString stringWithFormat:@"%@",_pid];
    if ([_queue intValue]!=1&&_queue!=nil) {
      mDic[@"queue"] = [NSString stringWithFormat:@"%@",_value];
      NSLog(@"__________queue==%@",mDic[@"queue"]);
    }
    
    mDic[@"number"] = [NSString stringWithFormat:@"%@",_number];
    if (_zg==nil) {
        _zg=[NSString stringWithFormat:@"0"];
    }
    mDic[@"zg"] = [NSString stringWithFormat:@"%@",_zg];
    NSLog(@"^^^^^^^^^^^^%@",_zg);
    NSDictionary *dic=@{@"code":@"playbefor",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jData withMethod:POST success:^(id result) {
        NSLog(@"66%@",result);
        _data=result[@"data"];
        NSLog(@"99%@",_data);
        [self addPayUI];
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:nil];
    
    
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

-(void)addPayUI{
//    if (!_yhLabel) {
    _viewArr=[NSMutableArray array];
    int high=60;
    for (int i=0; i<9; i++) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, i*(high+1), SCREEN_WIDTH, high)];
        view.backgroundColor=[UIColor whiteColor];
        view.tag=i;
        [_viewArr addObject:view];
        [self.view addSubview:view];
    }
    
    UIView *Nv=_viewArr[1];
    _name=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, high)];
    _name.numberOfLines=2;
    _name.text=[NSString stringWithFormat:@"商品名称:(第%@期)%@",_data[@"no"],_data[@"name"]];
    _name.font=[UIFont systemFontOfSize:15];
    _name.textColor=[UIColor blackColor];
    _name.numberOfLines =1;
    [Nv addSubview:_name];
    
    UIView *Hv=_viewArr[2];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:Hv.bounds];
    [btn addTarget:self action:@selector(HvAction) forControlEvents:UIControlEventTouchUpInside];
    [Hv addSubview:btn];
    
    UILabel *hbj=[[UILabel alloc]initWithFrame:CGRectMake(10, 21, 18, 18)];
    hbj.text=@"减";
    hbj.layer.masksToBounds=YES;
    hbj.layer.cornerRadius=2;
    hbj.textAlignment=NSTextAlignmentCenter;
    hbj.textColor=[UIColor whiteColor];
    hbj.backgroundColor=[UIColor redColor];
    hbj.font=[UIFont systemFontOfSize:15];
    [btn addSubview:hbj];
    
    
    UILabel *hbLabel=[[UILabel alloc]initWithFrame:CGRectMake(34, 0, 60, high)];
    hbLabel.font=[UIFont systemFontOfSize:13];
    hbLabel.text=@"红包减免";
    [btn addSubview:hbLabel];
    
    UILabel *syhb=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 0, 60, high)];
    syhb.font=[UIFont systemFontOfSize:13];
    syhb.text=@"使用红包";
    [btn addSubview:syhb];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-35, 20, 30, 20)];
    image.image=[UIImage imageNamed:@"nextlink"];
    [btn addSubview:image];
    
    
    UIView *Av=_viewArr[3];
    _ALable=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/3, high)];
    //_ALable.text=@"支付金额:";
    _ALable.font=[UIFont systemFontOfSize:13];
    _ALable.textColor=[UIColor blackColor];
    [Av addSubview:_ALable];
    NSString *jdStr=[NSString stringWithFormat:@"支付金额:¥%@",_data[@"price"]];
    NSRange range = [jdStr rangeOfString:[NSString stringWithFormat:@"¥%@",_data[@"price"]]];
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:jdStr];
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:range];
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:range];
   [aStr addAttribute:NSFontAttributeName value:[UIFont  fontWithName:@"Arial-BoldItalicMT" size:15.0] range:range];
    _ALable.attributedText = aStr;
    
    
    _yhLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3+10, 0, SCREEN_WIDTH/3, high)];
    _yhLabel.text=[NSString stringWithFormat:@"已优惠:¥"];
    _yhLabel.font=[UIFont systemFontOfSize:14];
    _yhLabel.textColor=[UIColor blackColor];
    [Av addSubview:_yhLabel];
    if (!_hb_money) {
        _hb_money=@"0.00";
    }
    NSString *jdStr1=[NSString stringWithFormat:@"已优惠:¥%@",_hb_money];
        NSLog(@"_______)_________%@",_hb_money);
    NSRange range1 = [jdStr1 rangeOfString:[NSString stringWithFormat:@"¥%@",_hb_money]];
    NSMutableAttributedString *aStr1 = [[NSMutableAttributedString alloc] initWithString:jdStr1];
    [aStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
    [aStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:range1];
    [aStr1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:15.0] range:range1];
    _yhLabel.attributedText = aStr1;

    
    UILabel* zfLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, high)];
    zfLabel.text=[NSString stringWithFormat:@"待支付:¥"];
    zfLabel.font=[UIFont systemFontOfSize:14];
    zfLabel.textColor=[UIColor blackColor];
    [Av addSubview:zfLabel];
    int p=[_data[@"price"] intValue]-[_hb_money intValue];
    _splay=[NSString stringWithFormat:@"%d",p];
    NSString *jdStr2=[NSString stringWithFormat:@"待支付:¥%@",_splay];
    NSRange range2 = [jdStr2 rangeOfString:[NSString stringWithFormat:@"¥%@",_splay]];
    NSMutableAttributedString *aStr2 = [[NSMutableAttributedString alloc] initWithString:jdStr2];
    [aStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"5CB85C"] range:range2];
    [aStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:range2];
    [aStr2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:20.0] range:range2];
    zfLabel.attributedText = aStr2;
    
    _payAmount=[[UILabel alloc]initWithFrame:CGRectMake(10+60, 0, 180, high)];
//    _payAmount.text=[NSString stringWithFormat:@"¥%@",_data[@"price"]];
    _payAmount.font=[UIFont systemFontOfSize:15];
    _payAmount.textColor=[UIColor redColor];
    [Av addSubview:_payAmount];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *newver = [userDefault objectForKey:@"newver"];
    
    UIView *Bv=_viewArr[4];
    if (IFNEWVER) {
  
    _balancePay=[[UIButton alloc]initWithFrame:CGRectMake(10, (high-15)/2 , 15, 15)];
    [_balancePay setImage:[UIImage imageNamed:@"paySelected"] forState:UIControlStateNormal];
    [_balancePay addTarget:self action:@selector(balancePayAction) forControlEvents:UIControlEventTouchUpInside];
    [Bv addSubview:_balancePay];
    
    UIImageView *yImage=[[UIImageView alloc]initWithFrame:CGRectMake(10+25,(high-25)/2, 25, 25)];
        yImage.image=[UIImage imageNamed:@"ypay"];
        [Bv addSubview:yImage];
        
        
    _BLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+25+30,(high-30)/2, 60, 30)];
    _BLabel.text=[NSString stringWithFormat:@"余额支付"];
    _BLabel.font=[UIFont systemFontOfSize:13];
    _BLabel.textColor=[UIColor blackColor];
    [Bv addSubview:_BLabel];
    
    _balance=[[UILabel alloc]initWithFrame:CGRectMake(10+25+60+30,(high-30)/2, 170, 30)];
    if ([_data[@"black"] isEqual:@"<null>"]) {
      _balance.text=@"(账户余额:0夺宝币)";
    }else{
      _balance.text=[NSString stringWithFormat:@"(账户余额:%@夺宝币)",_data[@"black"]];
    }
    _balance.font=[UIFont systemFontOfSize:13];
    _balance.textColor=[UIColor redColor];
    [Bv addSubview:_balance];
    
    Bv.userInteractionEnabled = YES;
    UITapGestureRecognizer * bvTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(balancePayAction)];
    bvTap.numberOfTouchesRequired = 1; //手指数
    bvTap.numberOfTapsRequired = 1; //tap次数
    bvTap.delegate= self;
    [Bv addGestureRecognizer:bvTap];
    
    }else{
     UILabel  *BLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,(high-30)/2, 100, 30)];
        BLabel.text=[NSString stringWithFormat:@"支付方式："];
        BLabel.font=[UIFont systemFontOfSize:13];
        BLabel.textColor=[UIColor blackColor];
        [Bv addSubview:BLabel];

        
    }
    UIView *Wv=_viewArr[5];
    _WXPay=[[UIButton alloc]initWithFrame:CGRectMake(10, (high-15)/2 , 15, 15)];
    [_WXPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];

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
    
    UIView *Zv=_viewArr[6];
    _ZPay=[[UIButton alloc]initWithFrame:CGRectMake(10, (high-15)/2 , 15, 15)];
    [_ZPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
    
    [_ZPay addTarget:self action:@selector(ZPayAction) forControlEvents:UIControlEventTouchUpInside];
    [Zv addSubview:_ZPay];
    
    UIImageView *ZImage=[[UIImageView alloc]initWithFrame:CGRectMake(10+25,(high-25)/2, 25, 25)];
    ZImage.image=[UIImage imageNamed:@"jdpay"];
    [Zv addSubview:ZImage];
    
    _Jlabel=[[UILabel alloc]initWithFrame:CGRectMake(10+25+30,(high-30)/2, 70, 30)];
    _Jlabel.text=[NSString stringWithFormat:@"京东支付"];
    _Jlabel.font=[UIFont systemFontOfSize:13];
    _Jlabel.textColor=[UIColor blackColor];
    [Zv addSubview:_Jlabel];
    
    Zv.userInteractionEnabled = YES;
    UITapGestureRecognizer * ZvTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ZPayAction)];
    ZvTap.numberOfTouchesRequired = 1; //手指数
    ZvTap.numberOfTapsRequired = 1; //tap次数
    ZvTap.delegate= self;
    [Zv addGestureRecognizer:ZvTap];
    
//    UIView *Jv=_viewArr[7];
//    _JPay=[[UIButton alloc]initWithFrame:CGRectMake(10, (high-15)/2 , 15, 15)];
//    [_JPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
//    
//    [_JPay addTarget:self action:@selector(JPayAction) forControlEvents:UIControlEventTouchUpInside];
//    [Jv addSubview:_JPay];
//    
//    UIImageView *jImage=[[UIImageView alloc]initWithFrame:CGRectMake(10+25,(high-25)/2, 25, 25)];
//    jImage.image=[UIImage imageNamed:@"jdpay"];
//    [Jv addSubview:jImage];
//    
//    _Jlabel=[[UILabel alloc]initWithFrame:CGRectMake(10+25+30,(high-30)/2, 70, 30)];
//    _Jlabel.text=[NSString stringWithFormat:@"京东支付"];
//    _Jlabel.font=[UIFont systemFontOfSize:13];
//    _Jlabel.textColor=[UIColor blackColor];
//    [Jv addSubview:_Jlabel];
//    
//    Jv.userInteractionEnabled = YES;
//    UITapGestureRecognizer * JvTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(JPayAction)];
//    JvTap.numberOfTouchesRequired = 1; //手指数
//    JvTap.numberOfTapsRequired = 1; //tap次数
//    JvTap.delegate= self;
//    [Jv addGestureRecognizer:JvTap];
    
    
    
    UIView *Pv=_viewArr[7];
    if ([_data[@"phone"] intValue]==0) {
        _phone=[[UIButton alloc]initWithFrame:CGRectMake(10,(high-25)/2, 80, 25)];
        _phone.titleLabel.font=SYSTEM_FONT(14);
        _phone.backgroundColor=kDefaultColor;
        _phone.layer.cornerRadius =4;
        _phone.layer.masksToBounds =YES;
        _phone.layer.rasterizationScale =kScreenScale;
        [_phone setTitle:@"绑定手机" forState:UIControlStateNormal];
        [_phone addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
        [Pv addSubview:_phone];
        
        _PLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+110,(high-25)/2, 180, 20)];
        _PLabel.text=@"未绑定手机不能支付";
        _PLabel.textColor=[UIColor blackColor];
        _PLabel.font=[UIFont systemFontOfSize:13];
        [Pv addSubview:_PLabel];
    }else {
        _phone=[[UIButton alloc]initWithFrame:CGRectMake(10,(high-20)/2, 120, 20)];
        _phone.titleLabel.font=SYSTEM_FONT(14);
        _phone.backgroundColor=[UIColor clearColor];
        [_phone setTitle:@"您绑定的手机为:" forState:UIControlStateNormal];
        [_phone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [Pv addSubview:_phone];
        
        NSString *ph=_data[@"phone"];
        NSString *lph=[ph substringToIndex:3];
        NSString *fph=[ph substringFromIndex:8];
        NSLog(@"((%@<<%@",lph,fph);
        
        _PLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+120,(high-20)/2, 180, 20)];
        _PLabel.text=[NSString stringWithFormat:@"%@*****%@",lph,fph];
        _PLabel.textColor=kDefaultColor;
        _PLabel.font=[UIFont systemFontOfSize:13];
        [Pv addSubview:_PLabel];
 }
    
    UIView *playView=[[UIView alloc]initWithFrame:CGRectMake(0,Pv.bottom+1, SCREEN_WIDTH, SCREEN_HEIGHT-Pv.bottom)];
    playView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:playView];
    
    _pay=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2,(high-40)/2, 200, 40)];
    _pay.titleLabel.font=SYSTEM_FONT(14);
    _pay.backgroundColor=kDefaultColor;
    _pay.layer.cornerRadius =4;
    _pay.layer.masksToBounds =YES;
    _pay.layer.rasterizationScale =kScreenScale;
    [_pay setTitle:@"立即支付" forState:UIControlStateNormal];
    [playView addSubview:_pay];
    [_pay addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
//    }
}
-(void)HvAction{
    NSLog(@"减免红包");
    RedEnvelopeViewController *snaVC=[[RedEnvelopeViewController alloc]init];
    snaVC.money_Delegate=self;
    snaVC.hbid_Delegate=self;
    snaVC.yfprice=[NSString stringWithFormat:@"%@",_data[@"price"]];
    [self.navigationController pushViewController:snaVC animated:YES];
}
//实现委托方法，即实现的setValue方法
- (void)setValue:(NSString *)string
{
    NSLog(@"A接收到B数据%@",string);
    _hb_money = string;
    
}
-(void)hbidsetValue:(NSString *)string{
    _hbid=string;
}
-(void)payAction{
    if([_data[@"phone"] intValue]>0 ){
    if(_select==1){
        NSLog(@"选择了余额支付");
        [self playYuebi];
    }
    if (_select==2) {
        NSLog(@"选择了微信支付");
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSString *newver = [userDefault objectForKey:@"newver"];
        
        
        if (IFNEWVER) {
            //[self goWXplay];
            [self payApp];
            //[self playwxApp];
        }else{
            [self palywxweb]; 
        }
      }
        if (_select==3) {
            NSLog(@"选择了京东支付");
            
            [self JDpaly];
            //[self goZFBPaly];
        }

    }else{
         [FormValidator showAlertWithStr:@"你未绑定手机号！"];
    }
    
}
-(void)JDpaly{
                    JDPayViewController *jd=[[JDPayViewController alloc]init];
//                    jd.price=_data[@"price"];
                    jd.price=_splay;
                    jd.pid=_pid;
                    if (_hbid) {
                        jd.hbid = [NSString stringWithFormat:@"%@",_hbid];
                    }else{
                        jd.hbid = [NSString stringWithFormat:@"%d",0];
                    }
                    if (_queue==nil) {
                        jd.queue=[NSString stringWithFormat:@"%d",1];
                    }else{
                    jd.queue=[NSString stringWithFormat:@"%@",_queue];
                    }
                    NSLog(@"price=%@  pid=%@ queue=%@",jd.price,jd.pid,jd.queue);
                    [self.navigationController pushViewController:jd animated:YES];
    
}
-(void)goWXplay{
    if (_sign_verify_==nil) {
        _sign_verify_ = [[SignFile alloc] init];
        
    }
    NSString *randomString = [NSString stringWithFormat:@"%d",(int)(100000 + (arc4random() % (900001)))];
    int p=[_data[@"price"] intValue];
    NSString *pice=[NSString stringWithFormat:@"%d",p*100];
    NSString *title=[NSString stringWithFormat:@"(第%@期)%@",_data[@"no"],_data[@"name"]];
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
    int p=[_data[@"price"] intValue];
    NSString *pice=[NSString stringWithFormat:@"%d",p*1];
    NSString *title=[NSString stringWithFormat:@"(第%@期)%@",_data[@"no"],_data[@"name"]];
    disArray = @[@"订单金额:",@"appId:",@"商品描述:",@"客户端Ip:",@"商户订单号:",@"商品标题:"];
    typeArray = @[pice,appId,@"非数字型商品",@"192.168.1.117",randomString,title,@"支付方式"];
    
    
    _handleDic = [NSMutableDictionary dictionaryWithObjects:@[typeArray[0],typeArray[1],typeArray[2],typeArray[3],randomString,typeArray[5],[QJPaySDK PAY_APLIPAY],@"ios_v1_1_5"] forKeys:@[@"amount",@"appid",@"body",@"clientIp",@"mchntOrderNo",@"subject",@"payChannelId",@"version"]];
    
    [QJPaySDK QJPayStart:_handleDic AppScheme:@"QJPaySDKGUI" appKey:app_Key  andCurrentViewController:self andDelegate:self Flag:0x80];
    
    
}

-(void)goJDPaly{
    if (_sign_verify_==nil) {
        _sign_verify_ = [[SignFile alloc] init];
        
    }
    NSString *randomString = [NSString stringWithFormat:@"%d",(int)(100000 + (arc4random() % (900001)))];
    int p=[_data[@"price"] intValue];
    NSString *pice=[NSString stringWithFormat:@"%d",p*1];
    NSString *title=[NSString stringWithFormat:@"(第%@期)%@",_data[@"no"],_data[@"name"]];
    disArray = @[@"订单金额:",@"appId:",@"商品描述:",@"客户端Ip:",@"商户订单号:",@"商品标题:"];
    typeArray = @[pice,appId,@"非数字型商品",@"192.168.1.117",randomString,title,@"支付方式"];
    
    
    _handleDic = [NSMutableDictionary dictionaryWithObjects:@[typeArray[0],typeArray[1],typeArray[2],typeArray[3],randomString,typeArray[5],[QJPaySDK PAY_JINGDONG],@"ios_v1_1_5"] forKeys:@[@"amount",@"appid",@"body",@"clientIp",@"mchntOrderNo",@"subject",@"payChannelId",@"version"]];
    
    [QJPaySDK QJPayStart:_handleDic AppScheme:@"dnsaPlay" appKey:app_Key  andCurrentViewController:self andDelegate:self Flag:0x80];
    
    
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
    if (_number==nil) {
        _number=[NSString stringWithFormat:@"%d",1];
    }
    self.token=[GJTokenManager accessToken];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"price"] = [NSString stringWithFormat:@"%@",_splay];
    mDic[@"pid"] = [NSString stringWithFormat:@"%@",_pid];
    if (_hbid) {
        mDic[@"hbid"] = [NSString stringWithFormat:@"%@",_hbid];
    }else{
        mDic[@"hbid"] = [NSString stringWithFormat:@"%d",0];
    }
    if ([_queue intValue]!=1) {
        mDic[@"queue"] = [NSString stringWithFormat:@"%@",_queue];
    }
    
    NSDictionary *dic=@{@"code":@"playwxapp",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jData withMethod:POST success:^(id result) {
        NSLog(@"55%@",result);
        _wxData=result[@"data"];
        [self SPay:_wxData];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weixinPayResult:) name:@"weixinPay" object:nil];   
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:nil];
    
    
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
-(void)palywxweb{
    _wxWebData=[NSMutableDictionary dictionary];
    self.token=[GJTokenManager accessToken];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"price"] = [NSString stringWithFormat:@"%@",_splay];
    
    mDic[@"pid"] = [NSString stringWithFormat:@"%@",_pid];
    if ([_queue intValue]!=1) {
        mDic[@"queue"] = [NSString stringWithFormat:@"%@",_queue];
    }
    mDic[@"zg"] = [NSString stringWithFormat:@"%@",_zg];
    NSLog(@"%@",mDic);
   
    [CKHttpCommunicate createTokenRequest:HTTP_WXWeb withToken:token WithParam:mDic withMethod:POST success:^(id result) {
        NSLog(@"77%@",result);
        
       _wxWebData=result;
         NSLog(@"88%@",_wxWebData);
        
        if (_wxWebData!=nil) {NSLog(@"---------%@",_wxWebData[@"no"]);
            NSString *str=[NSString stringWithFormat:@"http://www.duonisuoai.com/simple/pay_wx?code=%@&price=%@&no=%@&pid=%@&type=1",_wxWebData[@"code_url"],_wxWebData[@"price"],_wxWebData[@"no"],_wxWebData[@"pid"]];
            NSLog(@"_____%@",str);
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
       
 
        
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:nil];
    
    
    
    
}
-(void)playwxApp{
    _wxData=[NSMutableDictionary dictionary];
    if (_number==nil) {
        _number=[NSString stringWithFormat:@"%d",1];
    }
    self.token=[GJTokenManager accessToken];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"price"] = [NSString stringWithFormat:@"%@",_data[@"price"]];
    mDic[@"pid"] = [NSString stringWithFormat:@"%@",_pid];
    if ([_queue intValue]!=1) {
        mDic[@"queue"] = [NSString stringWithFormat:@"%@",_queue];
    }

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
        
    } showHUD:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weixinPayResult:) name:@"weixinPay" object:nil];
}
-(void)weixinPayResult:(NSDictionary*)dict{
    PayResultViewController *result=[[PayResultViewController alloc]init];
    result.url=_wxData[@"url"];
    [self.navigationController pushViewController:result animated:YES];
}

- (void)bizPay:(NSMutableDictionary *)dict {
     [WXApiRequestHandler jumpToBizPay:dict];
}

+ (NSString *)jumpToBizPay:(NSMutableDictionary *)dict {
    
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
                return @"支付成功";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
           // return @"服务器返回错误，未获取到json对象";
            return [dict objectForKey:@"retmsg"];
        }
}
-(void)playYuebi{
    _wxData=[NSMutableDictionary dictionary];
    if (_number==nil) {
        _number=[NSString stringWithFormat:@"%d",1];
    }
    self.token=[GJTokenManager accessToken];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"price"] = [NSString stringWithFormat:@"%@",_splay];
    mDic[@"pid"] = [NSString stringWithFormat:@"%@",_pid];
    if ([_queue intValue]!=1) {
        mDic[@"queue"] = [NSString stringWithFormat:@"%@",_queue];
    }
    if (_hbid) {
        mDic[@"hbid"] = [NSString stringWithFormat:@"%@",_hbid];
    }else{
        mDic[@"hbid"] = [NSString stringWithFormat:@"%d",0];
    }
    mDic[@"zg"] = [NSString stringWithFormat:@"%@",_zg];
    NSDictionary *dic=@{@"code":@"playyue",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jData withMethod:POST success:^(id result) {
        NSLog(@"33%@",result);
        if ([result[@"status"] isEqual:@(1)]) {
            //[FormValidator showAlertWithStr:result[@"msg"]];
            NSDictionary *data=result[@"data"];
            NSString * bseUrl=@"http://www.duonisuoai.com/pay/pay_result/sn/";
            NSString *url=[NSString stringWithFormat:@"%@%@",bseUrl,data[@"sn"]];
            PayResultViewController *result=[[PayResultViewController alloc]init];
            result.url=url;
            [self.navigationController pushViewController:result animated:YES];
            
        }else{
            [FormValidator showAlertWithStr:result[@"msg"]];
        }
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:nil];
    
}
-(void)balancePayAction{
    _select=1;
    [_WXPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
    [_balancePay setImage:[UIImage imageNamed:@"paySelected"] forState:UIControlStateNormal];
    [_ZPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
//    [_JPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
}

-(void)WXPayAction{
    _select=2;
   [_WXPay setImage:[UIImage imageNamed:@"paySelected"] forState:UIControlStateNormal];
   [_balancePay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
    [_ZPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
//   [_JPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
}
-(void)ZPayAction{
    _select=3;
    [_WXPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
    [_balancePay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
    [_ZPay setImage:[UIImage imageNamed:@"paySelected"] forState:UIControlStateNormal];
    //    [_JPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
    

}

//-(void)JPayAction{
//    _select=4;
//    [_WXPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
//    [_balancePay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
//    [_ZPay setImage:[UIImage imageNamed:@"payDefault"] forState:UIControlStateNormal];
//
//    [_JPay setImage:[UIImage imageNamed:@"paySelected"] forState:UIControlStateNormal];
//}

-(void)phoneAction{
    PhoneViewController *add=[[PhoneViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
    
}
//返回
- (void) back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
