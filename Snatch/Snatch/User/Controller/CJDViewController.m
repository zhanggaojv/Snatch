//
//  CJDViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/11/22.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "CJDViewController.h"
#import "UMSocialUIManager.h"
#import "WXApiRequestHandler.h"

@interface CJDViewController ()

@property (nonatomic,strong) UIImageView *pic;
@property (nonatomic,strong) NSString *imageurl;
@end

@implementation CJDViewController

- (void)viewDidLoad {
    self.title=@"成绩单";
    [super viewDidLoad];
    [self addBarButtonItem];
   
    [self sendHttpRequest];
     //[self addCJDViewUI];
    
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
/**
 *  发送网络请求，获取数据
 */
- (void)sendHttpRequest
{
    if ([GJTokenManager hasAvalibleToken]) {
        self.token=[GJTokenManager accessToken];
    }else{
        [FormValidator showAlertWithStr:@"登录已经失效，请重新登录"];
    }
    
    NSDictionary *dataDic=@{@"uid":_uid};
    NSLog(@"$$$$$$$$$$$$$$$$ %@",dataDic);
    NSDictionary *dic=@{@"code":@"chengji",@"data":dataDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jsondata withMethod:POST success:^(id result) {
        NSLog(@"_______777777_______result:%@",result);
        _data = result[@"data"];
        NSLog(@"___________data:%@",_data[@"uid"]);
     
        //cz_money heardimgurl next_per_money next_per_num proxyid uid
        [self addCJDViewUI];
        
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:nil];
    
    
}

-(void)addCJDViewUI{
    UIScrollView *scv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //[self.view addSubview:scv];
    [scv setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    scv.bounces=YES;
    scv.scrollEnabled=YES;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //scv.showsVerticalScrollIndicator=YES;
    scv.contentOffset = CGPointMake(0, 0);// 设置scrollView的滚动偏移量
    scv.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);// 设置scrollView额外顶部滚动区域:(UIEdgeInsetsMake是逆时针设置，上左下右)
    self.view=scv;
    
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"221f32"];
    UIView *cjdView=[UIView new];
    cjdView.backgroundColor=[UIColor colorWithHexString:@"eb5e5e"];
    cjdView.layer.masksToBounds=YES;
    cjdView.layer.cornerRadius=5;
    [self.view addSubview:cjdView];
    [cjdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.width/10*9, self.view.height/3*2-80));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    [self cjdView:cjdView];
    
    
    UIButton *btn=[UIButton new];
    btn.backgroundColor=[UIColor colorWithHexString:@"eb5e5e"];
    [btn setTitle:@"晒一晒" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(shaiyishai) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.width/10*9, 45));
        make.top.mas_equalTo(cjdView.mas_bottom).mas_offset(25);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    
    UIImageView *pic=[UIImageView new];
    pic.backgroundColor=[UIColor redColor];
    NSURL *imageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",_data[@"heardimgurl"]]];
    [pic sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"celldidan"]];
    pic.layer.masksToBounds=YES;
    pic.layer.cornerRadius=61;
    [self.view addSubview:pic];
    [pic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cjdView.mas_top);
        make.left.mas_equalTo(cjdView.mas_left).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(122, 121));
    }];
   
    
}
-(void)cjdView:(UIView *)cjdv{
    //cz_money heardimgurl next_per_money next_per_num proxyid uid

    _IDlabel=[UILabel new];
    _IDlabel.text=[NSString stringWithFormat:@"ID:%@",_data[@"uid"]];
    _IDlabel.textColor=[UIColor colorWithHexString:@"ffffff"];
    _IDlabel.font=[UIFont systemFontOfSize:18];
    [cjdv addSubview:_IDlabel];
    [_IDlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cjdv.mas_top).mas_offset(10);
        make.left.mas_equalTo(cjdv.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    _djLable=[UILabel new];
    
    _djLable.textColor=[UIColor colorWithHexString:@"ffffff"];
    _djLable.font=[UIFont systemFontOfSize:18];
    [cjdv addSubview:_djLable];
    [_djLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_IDlabel.mas_bottom);
        make.left.mas_equalTo(cjdv.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    _jd =[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    _jd.layer.masksToBounds = YES;
    _jd.layer.cornerRadius =6;
    [cjdv addSubview:_jd];
    [_jd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cjdv.mas_top).mas_offset(100);
        make.size.mas_equalTo(CGSizeMake(self.view.width/7*6, 11));
        make.centerX.mas_equalTo(cjdv.mas_centerX);
    }];
    
    _jd.trackTintColor = [UIColor colorWithHexString:@"ffffff"];
    
    [_jd setTintColor:[UIColor goldColor]];
    _jd.trackTintColor = [UIColor colorWithHexString:@"ffffff"];
    [_jd setTintColor:[UIColor goldColor]];
    
    
    UILabel *l=[UILabel new];
    l.textColor=[UIColor colorWithHexString:@"ffffff"];
    l.font=[UIFont systemFontOfSize:15];
    l.textAlignment=NSTextAlignmentLeft;
    [cjdv addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_jd.mas_top);
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.left.mas_equalTo(_jd.mas_left);
    }];
    
    UILabel *r=[UILabel new];
    r.textColor=[UIColor colorWithHexString:@"ffffff"];
    r.font=[UIFont systemFontOfSize:15];
    r.textAlignment=NSTextAlignmentRight;
    [cjdv addSubview:r];
    [r mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_jd.mas_top).mas_offset(1);
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.right.mas_equalTo(_jd.mas_right);
    }];
   
    NSLog(@"^^^^%d",[_data[@"cz_money"] intValue]);

    if ([_data[@"cz_money"] intValue]<1000) {
        _djLable.text=@"等级:男爵";
        _jd.progress = [_data[@"cz_money"] floatValue]/1000;
        l.text=@"1";
        r.text=@"1000";
    }else if([_data[@"cz_money"] intValue]<5000){
        _djLable.text=@"等级:子爵";
          _jd.progress = [_data[@"cz_money"] floatValue]/5000;
        l.text=@"1000";
        r.text=@"5000";
    }else if([_data[@"cz_money"] intValue]<10000){
         _djLable.text=@"等级:伯爵";
          _jd.progress = [_data[@"cz_money"] floatValue]/10000;
        l.text=@"5000";
        r.text=@"10000";
    }else if([_data[@"cz_money"] intValue]<100000){
         _djLable.text=@"等级:侯爵";
          _jd.progress = [_data[@"cz_money"] floatValue]/100000;
        l.text=@"10000";
        r.text=@"100000";
    }else if([_data[@"cz_money"] intValue]<500000){
         _djLable.text=@"等级:公爵";
          _jd.progress = [_data[@"cz_money"] floatValue]/500000;
        l.text=@"100000";
        r.text=@"500000";
    }else if([_data[@"cz_money"] intValue]<1000000){
         _djLable.text=@"等级:国王";
          _jd.progress = [_data[@"cz_money"] floatValue]/1000000;
        l.text=@"500000";
        r.text=@"1000000";
    }else if([_data[@"cz_money"] intValue]>1000000){
         _djLable.text=@"等级:至尊王者";
          _jd.progress = [_data[@"cz_money"] floatValue]/1000000;
        l.text=@"1000000";
        r.text=@"";
    }


    
    for (int i=0; i<4; i++) {
        UIView*line=[[UIView alloc]initWithFrame:CGRectMake(10, (self.view.height/3*2-80)/2+i*50, self.view.width/10*9-20, .5)];
        line.backgroundColor=[UIColor colorWithHexString:@"ffffff"];
        [cjdv addSubview:line];
    }
    
    _zhanghu=[[UILabel alloc]initWithFrame:CGRectMake(10, (self.view.height/3*2-80)/2-40, 200, 30)];
    _zhanghu.text=@"账户充值累积金额";
    _zhanghu.textColor=[UIColor colorWithHexString:@"ffffff"];
    _zhanghu.font=[UIFont systemFontOfSize:15];
    [cjdv addSubview:_zhanghu];
    
    _ZHje=[[UILabel alloc]initWithFrame:CGRectMake(self.view.width/10*9-20-100, (self.view.height/3*2-80)/2-40, 100, 30)];
    _ZHje.text=[NSString stringWithFormat:@"%@",_data[@"cz_money"]];
    [_ZHje setTextAlignment:NSTextAlignmentRight];
    _ZHje.textColor=[UIColor colorWithHexString:@"ffffff"];
    _ZHje.font=[UIFont systemFontOfSize:15];
    [cjdv addSubview:_ZHje];
    
    _xianxia=[[UILabel alloc]initWithFrame:CGRectMake(10, (self.view.height/3*2-80)/2+1*50-40, 200, 30)];
    _xianxia.text=@"线下人员充值总金额";
    _xianxia.textColor=[UIColor colorWithHexString:@"ffffff"];
    _xianxia.font=[UIFont systemFontOfSize:15];
    [cjdv addSubview:_xianxia];
    
    _XXje=[[UILabel alloc]initWithFrame:CGRectMake(self.view.width/10*9-20-100, (self.view.height/3*2-80)/2+1*50-40, 100, 30)];
    _XXje.text=[NSString stringWithFormat:@"%@",_data[@"next_per_money"]];
    [_XXje setTextAlignment:NSTextAlignmentRight];
    _XXje.textColor=[UIColor colorWithHexString:@"ffffff"];
    _XXje.font=[UIFont systemFontOfSize:15];
    [cjdv addSubview:_XXje];
    
    _renshu=[[UILabel alloc]initWithFrame:CGRectMake(10, (self.view.height/3*2-80)/2+2*50-40, 200, 30)];
    _renshu.text=@"线下人数";
    _renshu.textColor=[UIColor colorWithHexString:@"ffffff"];
    _renshu.font=[UIFont systemFontOfSize:15];
    [cjdv addSubview:_renshu];
    
    _rs=[[UILabel alloc]initWithFrame:CGRectMake(self.view.width/10*9-20-100, (self.view.height/3*2-80)/2+2*50-40, 100, 30)];
    _rs.text=[NSString stringWithFormat:@"%@",_data[@"next_per_num"]];
    [_rs setTextAlignment:NSTextAlignmentRight];
    _rs.textColor=[UIColor colorWithHexString:@"ffffff"];
    _rs.font=[UIFont systemFontOfSize:15];
    [cjdv addSubview:_rs];

    
    _dldj=[[UILabel alloc]initWithFrame:CGRectMake(10, (self.view.height/3*2-80)/2+3*50-40, 200, 30)];
    _dldj.text=@"代理等级";
    _dldj.textColor=[UIColor colorWithHexString:@"ffffff"];
    _dldj.font=[UIFont systemFontOfSize:15];
    [cjdv addSubview:_dldj];
    
    _daili=[[UILabel alloc]initWithFrame:CGRectMake(self.view.width/10*9-20-100, (self.view.height/3*2-80)/2+3*50-40, 100, 30)];
    [_daili setTextAlignment:NSTextAlignmentRight];
    _daili.textColor=[UIColor colorWithHexString:@"ffffff"];
    _daili.font=[UIFont systemFontOfSize:15];
    [cjdv addSubview:_daili];
    
    if ([_data[@"proxyid"] intValue]==1) {
        _daili.text=@"白银代理";
    }else if ([_data[@"proxyid"] intValue]==2){
        _daili.text=@"皇冠代理";
    }else{
        _daili.text=@"皇冠代理";
    }

    
}
//晒一晒
-(void)shaiyishai{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *newver = [userDefault objectForKey:@"newver"];

    if (IFNEWVER) {
        
        //显示分享面板
        
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
            
            [self shareWebPageToPlatformType:platformType];
        }];
    }    
    
}
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    _imageurl=@"http://www.duonisuoai.com/Template/Web/images/qrcode.png";
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"夺你所爱，一元圆梦。" descr:nil thumImage:_imageurl];
    //设置网页地址
    shareObject.webpageUrl =@"http://itunes.apple.com/us/app/id1144374028";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        //[self alertWithError:error];
        
    }];
    
}
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n",(int)error.code];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
