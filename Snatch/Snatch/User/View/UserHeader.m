//
//  UserHeader.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/6.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "UserHeader.h"
#import "Ems-cnplViewController.h"
#import "GJDocumentImage.h"

CGFloat bgImageViewY = -10.0;
CGFloat bgImageViewHeight = 170.0;
CGFloat headImageViewWidth = 80.0;
CGFloat headImageViewLeftMargin = 15.0;
CGFloat headImageViewRightMargin = 15.0;
CGFloat balanceViewHeight = 40.0;

@implementation UserHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self initUI];
        [self bringSubviewToFront:_userPic];
        [self bringSubviewToFront:_quan];
        [self bringSubviewToFront:_juewei];
    }
    return self;
}
-(void)initUI{
    _bgImageView = [UIImageView new];
    _bgImageView.origin = CGPointMake(0, bgImageViewY);
    _bgImageView.size = CGSizeMake(kScreenWidth, bgImageViewHeight);
    
    // 拿到沙盒路径图片
    _bgImage=[GJDocumentImage getDocumentImage];
    if (_bgImage) {
        _bgImageView.image = _bgImage;
    }else{
    _bgImageView.image = [UIImage imageNamed:@"header4"];
    }
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.clipsToBounds = YES;
    [self addSubview:_bgImageView];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
    // 允许用户交互
    _bgImageView.userInteractionEnabled = YES;
    
    [_bgImageView addGestureRecognizer:tap];
    
    
    _userPic = [UIButton new];
    _userPic.origin = CGPointMake(headImageViewLeftMargin, _bgImageView.bottom-headImageViewWidth*0.8);
    _userPic.size = CGSizeMake(headImageViewWidth, headImageViewWidth);
    _userPic.layer.cornerRadius = _userPic.width/2.0;
    _userPic.layer.masksToBounds = YES;
    _userPic.layer.shouldRasterize = YES;
    _userPic.layer.rasterizationScale = kScreenScale;
    _userPic.userInteractionEnabled = YES;
    _userPic.layer.borderWidth=2;
    _userPic.layer.borderColor=[UIColor whiteSmoke].CGColor;
    [_userPic addTarget:self action:@selector(userPicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.userPic];
    
    _quan = [UIImageView new];
    _quan.image = [UIImage imageNamed:@"hg"];
    [self addSubview:_quan];
    [_quan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_userPic.mas_top).mas_offset(13);
        make.left.mas_equalTo(_userPic.left).mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    _quan.hidden=YES;
    
    _juewei=[UIButton new];
   // _juewei.backgroundColor=[UIColor redColor];
    [self addSubview:_juewei];
    
    [_juewei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_userPic.mas_bottom).mas_offset(-25);
        make.centerX.mas_equalTo(_userPic.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(_userPic.width/6*5, 50));
    }];
    
    _userName=[[UILabel alloc]init];
    _userName.textColor=[UIColor whiteColor];
    _userName.font=[UIFont systemFontOfSize:16 ];
    [self addSubview:_userName];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(85);
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.left.mas_equalTo(self.mas_left).mas_offset(110);
    }];
    _jfImage=[[UIImageView alloc]init];
    _jfImage.image=[UIImage imageNamed:@"jifen"];
    [self addSubview:_jfImage];
    [self.jfImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userName.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(self.mas_left).mas_offset(110);
    }];
    _userRecordLabel=[[UILabel alloc]init];
    _userRecordLabel.text=@"积分:";
    _userRecordLabel.textColor=[UIColor whiteColor];
    _userRecordLabel.font=[UIFont systemFontOfSize:15 ];
    [self addSubview:_userRecordLabel];
    [self.userRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userName.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(40, 15));
        make.left.mas_equalTo(self.jfImage.mas_right).mas_offset(3);
    }];
    
    _userRecord=[[UILabel alloc]init];
    _userRecord.textColor=[UIColor whiteColor];
    _userRecord.adjustsFontSizeToFitWidth = YES;
    _userRecord.font=[UIFont systemFontOfSize:15 ];
    [self addSubview:_userRecord];
    [self.userRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userName.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(55, 15));
        make.left.mas_equalTo(self.userRecordLabel.mas_right).mas_offset(-3);
    }];
    _dlImage=[[UIImageView alloc]init];
    _dlImage.image=[UIImage imageNamed:@"dailidengji"];
    [self addSubview:_dlImage];
    [self.dlImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userName.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(_userRecord.mas_right);
    }];

    _userGrade=[[UILabel alloc]init];
    _userGrade.textColor=[UIColor whiteColor];
    _userGrade.font=[UIFont systemFontOfSize:15 ];
    [self addSubview:_userGrade];
    [self.userGrade mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userName.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(80, 15));
        make.left.mas_equalTo(self.dlImage.mas_right).mas_offset(3);
    }];
    
    _yqImage=[[UIImageView alloc]init];
    _yqImage.image=[UIImage imageNamed:@"yaoqingma"];
    [self addSubview:_yqImage];
    [self.yqImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userRecordLabel.mas_bottom).mas_offset(7);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(self.mas_left).mas_offset(110);
    }];


    _backLabel=[[UILabel alloc]init];
    _backLabel.text=@"邀请码:";
    _backLabel.textColor=[UIColor whiteColor];
    _backLabel.font=[UIFont systemFontOfSize:15 ];
    [self addSubview:_backLabel];
    [self.backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userRecordLabel.mas_bottom).mas_offset(7);
        make.size.mas_equalTo(CGSizeMake(55, 15));
        make.left.mas_equalTo(self.yqImage.mas_right).mas_offset(3);
    }];
    
    _back=[[UILabel alloc]init];
    _back.textColor=[UIColor whiteColor];
    _back.font=[UIFont systemFontOfSize:15 ];
    [self addSubview:_back];
    [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userRecordLabel.mas_bottom).mas_offset(7);
        make.size.mas_equalTo(CGSizeMake(70, 15));
        make.left.mas_equalTo(self.backLabel.mas_right);
    }];

   
    _Sign =[[UIButton alloc]init];
    [self addSubview:_Sign];
    [_Sign addTarget:self action:@selector(signAction) forControlEvents:UIControlEventTouchUpInside];
    [_Sign mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(self.userRecordLabel.mas_bottom);
        make.right.mas_equalTo(self.mas_right).mas_offset(-2);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
        _balanceAmountView  = [[UIView alloc] initWithFrame:({
        CGRect rect = {
            0,
            _bgImageView.bottom,
            kScreenWidth,
            balanceViewHeight};
        rect;
    })];
    _balanceAmountView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_balanceAmountView];
    _balanceAmountView.layer.masksToBounds=YES;
    _balanceAmountView.layer.cornerRadius=0;
    _balanceAmountView.layer.borderWidth=1;
    _balanceAmountView.layer.borderColor=[UIColor whiteSmoke].CGColor;
    _balanceAmountView.backgroundColor=[UIColor whiteColor];
    [self addBalanceAmountView];
   // [self CustomerServices];
}
// 点击头像进入系统相册
- (void)doTap:(NSString *)str{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
    // 设置图片来源
    imagePick.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePick.delegate = self;
    imagePick.allowsEditing = YES;
    // 进入系统相册
    [self.nav presentViewController:imagePick animated:YES completion:nil];
}

//遵守协议  <UIImagePickerControllerDelegate, UINavigationControllerDelegate>实现代理方法

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
   
    //把相册取出的图片存进沙盒
    [GJDocumentImage saveImageDocuments:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)userPicAction{
    NSLog(@"个人信息");
    self.nav.hidesBottomBarWhenPushed=YES;
    UserInfoViewController *userInfoVC=[[UserInfoViewController alloc]init];
    userInfoVC.userUrl=@"/user/user_update";
    [self.nav.navigationController pushViewController:userInfoVC animated:YES];
    
//    UserMeansViewController *userInfoVC=[[UserMeansViewController alloc]init];
//    [self.nav.navigationController pushViewController:userInfoVC animated:YES];
//    userInfoVC.headimgUrl=_userInfoModel.imgUrl;
//    userInfoVC.nickname=_userInfoModel.nickname;
    self.nav.hidesBottomBarWhenPushed=NO;
}
-(void)signAction{
    NSLog(@"签到");
    NSDictionary *dic=@{@"code":@"qiandao"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];

    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result) {
//        [_Sign setTitle:@"已签到" forState:UIControlStateNormal];
        [_Sign setImage:[UIImage imageNamed:@"yiqiandao-"] forState:UIControlStateNormal];

    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:self];
    

}
-(void)agencyAction{
    NSLog(@"升级代理");
    AgencyViewController *agencyVC=[[AgencyViewController alloc]init];
    agencyVC.Url=@"/proxy/apply";
    [self.nav.navigationController pushViewController:agencyVC animated:YES];
}
-(void)addBalanceAmountView{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *newver = [userDefault objectForKey:@"newver"];
    if (IFNEWVER) {
    _balanceAmountImg =[[UIImageView alloc]init];
    _balanceAmountImg.image=[UIImage imageNamed:@"jinbi"];
    [self.balanceAmountView addSubview:_balanceAmountImg];
    [self.balanceAmountImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceAmountView.mas_left).mas_equalTo(100);
        make.centerY.mas_equalTo(self.balanceAmountView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 25));
    }];
    

    
    _balanceAmountlabel =[[UILabel alloc]init];
    _balanceAmountlabel.text = @"余额:";
    _balanceAmountlabel.font=[UIFont systemFontOfSize:14];
    _balanceAmountlabel.textColor=LightBlackLabelTextColor;
    [self.balanceAmountView addSubview:_balanceAmountlabel];
    [self.balanceAmountlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceAmountImg.mas_right).mas_offset(3);
        make.centerY.mas_equalTo(self.balanceAmountView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    _balanceAmount =[[UILabel alloc]init];
    _balanceAmount.font=[UIFont systemFontOfSize:14];
    _balanceAmount.textColor=LightBlackLabelTextColor;
    [self.balanceAmountView addSubview:_balanceAmount];
    [self.balanceAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceAmountlabel.mas_right);
        make.centerY.mas_equalTo(self.balanceAmountView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    }
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    
//    NSString *newver = [userDefault objectForKey:@"newver"];
    
    
    if (IFNEWVER) {
    _balanceAmountBtn =[[UIButton alloc]init];
    [_balanceAmountBtn setTitle:@"充值" forState:UIControlStateNormal];
    _balanceAmountBtn.titleLabel.font=SYSTEM_FONT(15);
//    _balanceAmountBtn.backgroundColor=[UIColor colorWithHexString:@"eb4f38"];
        _balanceAmountBtn.backgroundColor=[UIColor lightSeaGreen];
    _balanceAmountBtn.layer.cornerRadius =3;
    _balanceAmountBtn.layer.masksToBounds =YES;
    _balanceAmountBtn.layer.rasterizationScale =kScreenScale;
    [_balanceAmountBtn addTarget:self action:@selector(balanceAmountAction) forControlEvents:UIControlEventTouchUpInside];
    [self.balanceAmountView addSubview:_balanceAmountBtn];
    [self.balanceAmountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceAmount.mas_right);
        make.centerY.mas_equalTo(self.balanceAmountView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    }
}
-(void)balanceAmountAction{
    NSLog(@"充值");
    BalanceViewController *balanceVC=[[BalanceViewController alloc]init];
    [self.nav.navigationController pushViewController:balanceVC animated:YES];
    
}
- (void)makeScaleForScrollView:(UIScrollView *)scrollView {
    CGFloat scale = fabs(scrollView.contentOffset.y/bgImageViewHeight);
    _bgImageView.layer.position = CGPointMake(kScreenWidth/2.0, (scrollView.contentOffset.y+ (bgImageViewY+0.5*bgImageViewHeight)*2)/2);
    _bgImageView.transform = CGAffineTransformMakeScale(1+scale, 1+scale);
    
}

-(void)setUserInfoModel:(UserInfoModel *)userInfoModel{
    _userInfoModel = userInfoModel;
    [_userPic sd_setImageWithURL:_userInfoModel.imgUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang"]];
    _userName.text=_userInfoModel.nickname;
    _userRecord.text =_userInfoModel.score;
    if ([_userInfoModel.proxyid intValue]==1) {
        _userGrade.text=@"白银代理";
    }else if ([_userInfoModel.proxyid intValue]==2){
        _userGrade.text=@"皇冠代理";
    }else{
        _userGrade.text=@"皇冠代理";
    }
    
    _back.text=_userInfoModel.ID;
    _balanceAmount.text=_userInfoModel.black;
    NSLog(@"^^^^%d",[_userInfoModel.black intValue]);
    if ([_userInfoModel.cz_money intValue]<1000) {
        [_juewei setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    }else if([_userInfoModel.cz_money intValue]<5000){
        [_juewei setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    }else if([_userInfoModel.cz_money intValue]<10000){
        [_juewei setImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
    }else if([_userInfoModel.cz_money intValue]<100000){
        [_juewei setImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    }else if([_userInfoModel.cz_money intValue]<500000){
        [_juewei setImage:[UIImage imageNamed:@"5"] forState:UIControlStateNormal];
    }else if([_userInfoModel.cz_money intValue]<1000000){
        _quan.hidden=NO;
        
        [_juewei setImage:[UIImage imageNamed:@"6"] forState:UIControlStateNormal];
    }else if([_userInfoModel.cz_money intValue]>1000000){
        
        _userName.textColor=kDefaultColor;
        [_juewei setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
    }
    
    
    _SignState=_userInfoModel.qdstatus;
    if([_SignState intValue]==1){
//         [_Sign setTitle:@"已签到" forState:UIControlStateNormal];
        [_Sign setImage:[UIImage imageNamed:@"yiqiandao-"] forState:UIControlStateNormal];
    }else{
//        [_Sign setTitle:@"签到" forState:UIControlStateNormal];
        [_Sign setImage:[UIImage imageNamed:@"qiandao"] forState:UIControlStateNormal];
    }
}
//-(void)CustomerServices{
//    NSMutableArray *titleArr=[NSMutableArray arrayWithObjects:@"一键加群",@"加入微聊",@"关注公众号", nil];
//    
//    UIView *customerView=[[UIView alloc]init];
//    customerView.layer.masksToBounds=YES;
//    customerView.layer.borderWidth=2;
//    customerView.layer.borderColor=[UIColor whiteSmoke].CGColor;
//    customerView.backgroundColor=[UIColor whiteColor];
//    [self addSubview:customerView];
//    [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_balanceAmountView.mas_bottom).mas_offset(0);
//        
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 70));
//        
//    }];
//    for (int i=0; i<3; i++) {
//        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(i*(SCREEN_WIDTH/3)+(SCREEN_WIDTH/3)/2-50/2, 0, 50, 50)];
//        btn.tag=i;
//        NSString *str=[NSString stringWithFormat:@"qun%d",i];
//        [btn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
//        [customerView addSubview:btn];
//        [btn addTarget:self action:@selector(customerAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(i*(SCREEN_WIDTH/3), 40, SCREEN_WIDTH/3, 20)];
//        lab.text=titleArr[i];
//        lab.font=[UIFont systemFontOfSize:13];
//        lab.textAlignment=NSTextAlignmentCenter;
//        [customerView addSubview:lab];
//    }
//    
//    
//}
-(void)customerAction:(UIButton *)btn{
    switch (btn.tag) {
        case 0:{
            NSLog(@"一键加群");
            [self joinGroup:@"581940643" key:@"2823307dac56b4189c5f8af460dd93a9b145cf73a5d1685e28c2a70eceac171a"];
        }
            break;
        case 1:{
            NSLog(@"加入微信群");
            JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc]init];
            req.profileType = WXBizProfileType_Normal;
            req.username = @"gh_9153ca8a4385"; //公众号原始ID
            req.extMsg = @"";
            [WXApi sendReq:req];
        }
            break;
        case 2:{
//            OpenWebviewReq *req = [OpenWebviewReq new];
//            req.url = @"http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzIwNDQzNDcwMA==#wechat_webview_type=1&wechat_redirect";
//             req.url = @"http://weixin.qq.com/r/2kUXDyXEJnhZrWFs9xDI";
//            [WXApi sendReq:req];
            self.nav.hidesBottomBarWhenPushed=YES;
            Ems_cnplViewController *ems=[[Ems_cnplViewController alloc]init];
            [self.nav.navigationController pushViewController:ems animated:YES];
            self.nav.hidesBottomBarWhenPushed=NO;
            NSLog(@"关注公众号");
        }
            break;
        default:
            break;
    }
    
    
    
}
- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"581940643",@"2823307dac56b4189c5f8af460dd93a9b145cf73a5d1685e28c2a70eceac171a"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}
@end
