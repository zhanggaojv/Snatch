//
//  UserViewController.m
//  夺你所爱
//
//  Created by Zhanggaoju on 16/9/20.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "UserViewController.h"
#import "UserCell.h"
#import "UserHeader.h"
#import "Menudata.h"
#import "UserInfoModel.h"
#import "GJTokenManager.h"

#import "PopupView.h"
#import "LewPopupViewAnimationSlide.h"
#import "LuckyRecordViewController.h"
#import "JSONStrToDict.h"
#import "WXApiRequestHandler.h"
#import "CJDViewController.h"



@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIActionSheetDelegate>

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UserHeader *headerView;

@property (nonatomic,strong) Menudata *menuData;

@property (nonatomic,strong) UserInfoModel *sArr;

@property (nonatomic) BOOL kuaijie;

@property (nonatomic,strong) UIImageView *sentImg;

@end

@implementation UserViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self addBarButtonItem];
   // [self sendHttpRequest];
    [self Http_playbefor];
    [self NetworkStatus];
    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *newver = [userDefault objectForKey:@"newver"];
//     if (IFNEWVER) {
//         [self HongbaoNotification];
//     }
}
-(void)addBarButtonItem{
    UIImage* Limage= [UIImage imageNamed:@"erweima"];
    CGRect Lframe= CGRectMake(0, 0, 20, 20);
    UIButton *LsomeButton= [[UIButton alloc] initWithFrame:Lframe];
    [LsomeButton addTarget:self action:@selector(Lback) forControlEvents:UIControlEventTouchUpInside];
    [LsomeButton setBackgroundImage:Limage forState:UIControlStateNormal];
    [LsomeButton setShowsTouchWhenHighlighted:YES];
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:LsomeButton];
    
    UIImage* Rimage= [UIImage imageNamed:@"xiaoxi"];
    CGRect Rframe= CGRectMake(0, 0, 20, 20);
    UIButton *RsomeButton= [[UIButton alloc] initWithFrame:Rframe];
    [RsomeButton addTarget:self action:@selector(Rback) forControlEvents:UIControlEventTouchUpInside];
    [RsomeButton setBackgroundImage:Rimage forState:UIControlStateNormal];
    [RsomeButton setShowsTouchWhenHighlighted:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RsomeButton];
    
}
//返回
- (void)Lback {
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5*4, SCREEN_WIDTH/5*4)];
    _contentView.backgroundColor = [UIColor whiteSmoke];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((_contentView.width-150)/2, (_contentView.width-150)/2, 150, 150)];
    imageV.image=[UIImage imageNamed:@"yaoqing"];
    imageV.userInteractionEnabled=YES;

    [_contentView addSubview:imageV];
    
    UILabel *tipLb=[[UILabel alloc]initWithFrame:CGRectMake((_contentView.width-150)/2,(_contentView.width-150)/2+150,150, 30)];
    tipLb.numberOfLines=1;
    [tipLb setTextAlignment:NSTextAlignmentCenter];
    tipLb.text=@"扫一扫邀请好友";
    tipLb.textColor=[UIColor blackColor];
    tipLb.alpha=.8;
    tipLb.font=[UIFont systemFontOfSize:18 weight:4];
    [_contentView addSubview:tipLb];
    
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:YES];

    
//    UITapGestureRecognizer *tap =   [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTapCliclk:)];
//     [imageV addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer*longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];
    [imageV addGestureRecognizer:longTap];

}
-(void)imglongTapClick:(UILongPressGestureRecognizer*)gesture

{
    
    if(gesture.state==UIGestureRecognizerStateBegan)
        
    {
        
        UIActionSheet*actionSheet = [[UIActionSheet alloc]initWithTitle:@"保存图片"delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"保存图片到手机",nil];
        
        actionSheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
        
        [actionSheet showInView:_contentView];
        
        UIImageView*img = (UIImageView*)[gesture view];
        
        _sentImg= img;
        
    }
    
}
-(void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==0)
    {
        UIImageWriteToSavedPhotosAlbum(_sentImg.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}
#pragma mark --- UIActionSheetDelegate---

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{
    
    NSString *message = @"呵呵";
    
    if (!error) {
        
        message = @"成功保存到相册";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
        
        
    }else
        
    {
        
        message = [error description];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
    }
    
}



- (void)Rback {
    self.hidesBottomBarWhenPushed=YES;
    AnnouncementViewController *annVC=[[AnnouncementViewController alloc]init];
    annVC.Url=@"/news/index/id/1";
    [self.navigationController pushViewController:annVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
-(void)Http_playbefor{
    _data=[NSMutableDictionary dictionary];
    self.token=[GJTokenManager accessToken];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    
    NSDictionary *dic=@{@"code":@"playbefor"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jData withMethod:POST success:^(id result) {
        NSLog(@"66%@",result);
        _data=result[@"data"];
        NSLog(@"99%@",_data);
        _phone=_data[@"phone"];
        
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:nil];
}
-(void)NetworkStatus{
    
    Reachability *reachability=[Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
            
        case NotReachable:
            [self loadCacheData];
            break;
        case ReachableViaWiFi:
            [self sendHttpRequest];
            break;
        case ReachableViaWWAN:
            [self sendHttpRequest];
            break;
    }
    [self addUserTableVIewUI];
}
-(void)loadCacheData{
    //获取缓存数据
    //参数:数据请求URL
    id cacheJson = [XHNetworkCache cacheJsonWithURL:@"UserCache"];
    NSLog(@"缓存数据:%@",cacheJson);
    _sArr = [UserInfoModel mj_objectWithKeyValues:cacheJson];
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
    

    NSDictionary *dic=@{@"code":@"userIndex"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jsondata withMethod:POST success:^(id result) {
        NSLog(@"______________result:%@",result);
        NSMutableArray *arr = result[@"data"];
        NSLog(@"___________arr;%@",arr);
        
        _sArr = [UserInfoModel mj_objectWithKeyValues:arr];

        NSLog(@"___________sArr;%@",_sArr.nickname);
        [MobClick profileSignInWithPUID:_sArr.ID];
    
        //(同步)写入/更新缓存数据
        //参数1:JSON数据,参数2:数据请求URL
        BOOL sureCache = [XHNetworkCache saveJsonResponseToCacheFile:arr andURL:@"UserCache"];
        if(sureCache)
        {
            NSLog(@"(同步)写入/更新缓存数据 成功");
        }
        else
        {
            NSLog(@"(同步)写入/更新缓存数据 失败");
        }

    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:self.view];
}
-(void)loadNewData{
    self.token=[GJTokenManager accessToken];
    NSLog(@"––––––––––––%@",self.token);
    
    NSDictionary *dic=@{@"code":@"userIndex"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jsondata withMethod:POST success:^(id result) {
        NSLog(@"______________result:%@",result);
        NSArray *arr = result[@"data"];
        NSLog(@"___________arr;%@",arr);
        NSDictionary *dic=result[@"data"];
        _sArr = [UserInfoModel mj_objectWithKeyValues:arr];
        NSLog(@"%@",dic[@"id"]);
       
        [_headerView removeAllSubviews];
        [self addHeaderView];
        [_tableView.mj_header endRefreshing];
        NSLog(@"___________sArr;%@",_sArr.nickname);
        
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
         [_tableView.mj_header endRefreshing];
    } showHUD:nil];

}

/**
 *  布局UI界面
 */
-(void)addUserTableVIewUI{
    _menuData=[[Menudata alloc]init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-120) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setShowsVerticalScrollIndicator:YES];
    [_tableView setBackgroundColor:self.view.backgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;//防止下沉
    [self addHeaderView];
}
-(void)addHeaderView{
    _headerView = [[UserHeader alloc]initWithFrame:({
        CGRect rect = {0, 0, kScreenWidth, 200};
        rect;
    })];
    _headerView.userInfoModel=_sArr;
    _headerView.nav=self;
    _tableView.tableHeaderView = _headerView;
}
#pragma mark - tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.menuData.textData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rowsArray=self.menuData.textData[section];
    return rowsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"UserCell";
    UserCell *userCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!userCell) {
        userCell=[[UserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    userCell.menuImgView.image=IMAGE_NAMED(self.menuData.imageData[indexPath.section][indexPath.row]);
    userCell.menuLabel.text=self.menuData.textData[indexPath.section][indexPath.row];
    userCell.layer.masksToBounds=YES;
    userCell.layer.cornerRadius=1;
    userCell.layer.borderWidth=1;
    userCell.layer.borderColor=[UIColor whiteSmoke].CGColor;
    userCell.backgroundColor=[UIColor whiteColor];
    userCell.selectionStyle = UITableViewCellSelectionStyleNone;//点击颜色

    return userCell;
    
}

//设置表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
    self.hidesBottomBarWhenPushed=YES;
    if(indexPath.section==0){
        NSLog(@"一键加群");
        [self joinGroup:@"581940643" key:@"2823307dac56b4189c5f8af460dd93a9b145cf73a5d1685e28c2a70eceac171a"];
    }
    
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0: {
                NSLog(@"成绩单");
                CJDViewController *cjdVC=[[CJDViewController alloc]init];
                cjdVC.uid=_sArr.ID;
                NSLog(@"000000000 %@",cjdVC.uid);
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *newver = [userDefault objectForKey:@"newver"];
                
                if (IFNEWVER) {
                [self.navigationController wxs_pushViewController:cjdVC animationType:WXSTransitionAnimationTypeSysCubeFromRight];
                }else{
                    [self.navigationController pushViewController:cjdVC animated:YES];
                }
                
            }
                break;
            case 1: {
                NSLog(@"夺宝明细");
                SnatchRecordViewController *snaVC=[[SnatchRecordViewController alloc]init];
                snaVC.Url=@"/user/records";
                
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *newver = [userDefault objectForKey:@"newver"];
                if (IFNEWVER) {
                   [self.navigationController wxs_pushViewController:snaVC animationType:WXSTransitionAnimationTypeSysCubeFromRight];
                }else{
                    [self.navigationController pushViewController:snaVC animated:YES];
                }
            }
                break;
            case 2: {
                NSLog(@"中奖记录");
                LuckyRecordViewController *snaVC=[[LuckyRecordViewController alloc]init];
                snaVC.Url=@"/user/lottery";
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *newver = [userDefault objectForKey:@"newver"];
                if (IFNEWVER) {
                    [self.navigationController wxs_pushViewController:snaVC animationType:WXSTransitionAnimationTypeSysCubeFromRight];
                }else{
                    [self.navigationController pushViewController:snaVC animated:YES];
                }

            }
                break;
            case 3: {
                NSLog(@"分组夺宝");
                SnatchRecordViewController *snaVC=[[SnatchRecordViewController alloc]init];
                snaVC.Url=@"/user/group_lottery";
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *newver = [userDefault objectForKey:@"newver"];
                if (IFNEWVER) {
                    [self.navigationController wxs_pushViewController:snaVC animationType:WXSTransitionAnimationTypeSysCubeFromRight];
                }else{
                    [self.navigationController pushViewController:snaVC animated:YES];
                }

            }
                break;
            case 4: {
                NSLog(@"积分兑换");
                SnatchRecordViewController *snaVC=[[SnatchRecordViewController alloc]init];
                snaVC.Url=@"/user/jifen_exchange";
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *newver = [userDefault objectForKey:@"newver"];
                if (IFNEWVER) {
                    [self.navigationController wxs_pushViewController:snaVC animationType:WXSTransitionAnimationTypeSysCubeFromRight];
                }else{
                    [self.navigationController pushViewController:snaVC animated:YES];
                }

            }
                break;
      
        }
    }
    if (indexPath.section==2) {
        switch (indexPath.row) {
            case 0: {
                NSLog(@"我的红包");
                RechargeViewController *snaVC=[[RechargeViewController alloc]init];
                snaVC.Url=@"/user/hongbao";
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *newver = [userDefault objectForKey:@"newver"];
                if (IFNEWVER) {
                    [self.navigationController wxs_pushViewController:snaVC animationType:WXSTransitionAnimationTypeSysCubeFromRight];
                }else{
                    [self.navigationController pushViewController:snaVC animated:YES];
                }

            }
                break;
            case 1: {
                NSLog(@"邀请好友");
                SnatchRecordViewController *snaVC=[[SnatchRecordViewController alloc]init];
                snaVC.Url=@"/user/tpl/type/friend";
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *newver = [userDefault objectForKey:@"newver"];
                if (IFNEWVER) {
                    [self.navigationController wxs_pushViewController:snaVC animationType:WXSTransitionAnimationTypeSysCubeFromRight];
                }else{
                    [self.navigationController pushViewController:snaVC animated:YES];
                }

            }
                break;
            case 2: {
                NSLog(@"地址管理");
                SnatchRecordViewController *snaVC=[[SnatchRecordViewController alloc]init];
                snaVC.Url=@"/user/address";
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *newver = [userDefault objectForKey:@"newver"];
                if (IFNEWVER) {
                    [self.navigationController wxs_pushViewController:snaVC animationType:WXSTransitionAnimationTypeSysCubeFromRight];
                }else{
                    [self.navigationController pushViewController:snaVC animated:YES];
                }

            }
                break;
            case 3: {
                NSLog(@"绑定手机");
                
                PhoneViewController *snaVC=[[PhoneViewController alloc]init];
                //                snaVC.Url=@"/user/bing_phone";
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *newver = [userDefault objectForKey:@"newver"];
                if (IFNEWVER) {
                    [self.navigationController wxs_pushViewController:snaVC animationType:WXSTransitionAnimationTypeSysCubeFromRight];
                }else{
                    [self.navigationController pushViewController:snaVC animated:YES];
                }

              
            }
                break;
        }
    }
    if (indexPath.section==3) {
        switch (indexPath.row) {
            case 0: {
                NSLog(@"个人设置");
                SettingViewController *settingVC=[[SettingViewController alloc]init];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *newver = [userDefault objectForKey:@"newver"];
                if (IFNEWVER) {
                    [self.navigationController wxs_pushViewController:settingVC animationType:WXSTransitionAnimationTypeSysCubeFromRight];
                }else{
                    [self.navigationController pushViewController:settingVC animated:YES];
                }


            }
                break;
        }
    }
    self.hidesBottomBarWhenPushed=NO;
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

//点击后，过段时间cell自动取消选中
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
//头部动画
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        [_headerView makeScaleForScrollView:scrollView];
    }
}
/**
 *红包通知
 */
-(void)HongbaoNotification{
    if ([GJTokenManager hasAvalibleToken]) {
        self.token=[GJTokenManager accessToken];
        NSLog(@"––––––––––––%@",self.token);
    }
    
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    NSDictionary *dic=@{@"code":@"showHB"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jsondata withMethod:POST success:^(id result) {
        NSLog(@"%@",result);
        NSLog(@"%@",result[@"msg"]);
        NSDictionary *data=result[@"data"];
        if ([result[@"status"] integerValue]==0) {
            NSLog(@"没有红包");
        }else if([result[@"status"] integerValue]==1){
            NSString *title=data[@"title"];
            NSLog(@"%@",title);
            [self hongbaoView:title];
            
        }else if([result[@"status"] integerValue]==2){
            NSString *resource=data[@"resource"];
            NSString *indexFirst=@"indexFirst";
            NSLog(@"———resource=%@",resource);
            
            if ([resource isEqualToString:indexFirst]) {
                [self DLCZSongView];
            }
            
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:nil];
    
}
-(void)hongbaoView:(NSString *)title{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5*4, SCREEN_HEIGHT/5*4)];
    _contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:_contentView.bounds];
    imageV.image=[UIImage imageNamed:@"ZJ"];
    [_contentView addSubview:imageV];
    
    UILabel *tipLb=[[UILabel alloc]initWithFrame:CGRectMake((_contentView.width-200)/2, SCREEN_HEIGHT/5*2+50, 200, 30)];
    tipLb.numberOfLines=2;
    [tipLb setTextAlignment:NSTextAlignmentCenter];
    tipLb.text=@"夺你所爱恭喜您获得";
    tipLb.textColor=[UIColor whiteColor];
    tipLb.alpha=.8;
    tipLb.font=[UIFont systemFontOfSize:20 weight:8];
    [_contentView addSubview:tipLb];
    
    UILabel *titleLb=[[UILabel alloc]initWithFrame:CGRectMake((_contentView.width-200)/2, SCREEN_HEIGHT/5*2+80, 200, 60)];
    titleLb.numberOfLines=2;
    [titleLb setTextAlignment:NSTextAlignmentCenter];
    titleLb.text=title;
    titleLb.textColor=[UIColor redColor];
    titleLb.alpha=.8;
    titleLb.font=[UIFont systemFontOfSize:20 weight:7];
    [_contentView addSubview:titleLb];
    
    
    
    UIButton *chakanBtn=[[UIButton alloc]initWithFrame:CGRectMake((_contentView.width-200)/2, SCREEN_HEIGHT/5*3, 200, 100)];
    [chakanBtn addTarget:self action:@selector(GotoKJ) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:chakanBtn];
    
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:YES];
    
}
-(void)GotoKJ{
    [[HWPopTool sharedInstance] closeWithBlcok:^{
        self.hidesBottomBarWhenPushed=YES;
        LuckyRecordViewController *luck=[LuckyRecordViewController alloc];
        [self.navigationController pushViewController:luck animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }];
}
-(void)DLCZSongView{
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5*4, SCREEN_HEIGHT/5*4)];
    _contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:_contentView.bounds];
    imageV.image=[UIImage imageNamed:@"CZS"];
    [_contentView addSubview:imageV];
    
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:YES];
    
    int high=60;
    for (int i=0; i<5; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0,300+i*(high+1), imageV.bounds.size.width, high)];
        btn.backgroundColor=[UIColor clearColor];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"cz0%d",i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(DLCZAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        [_contentView addSubview:btn];
    }
    
}

-(void)DLCZAction:(UIButton*)btn{
    if (btn.tag==0) {
        [[HWPopTool sharedInstance] closeWithBlcok:^{
            //NSString *url=@"/pay/pay_weixin_app/price/100/pid/0/hb/1";
            NSString *token=[NSString stringWithFormat:@"%@",self.token];
            NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
            mDic[@"price"] = @"100";
            mDic[@"pid"] = @"0";
            mDic[@"hb"] = @"1";
            
            [CKHttpCommunicate createTokenRequest:HTTP_WX withToken:token WithParam:mDic withMethod:POST success:^(id result) {
                NSLog(@"$$$$$$$$$______%@",result);
                NSMutableDictionary *data = result[@"data"];
                [self bizPay:data];
            } failure:^(NSError *erro) {
                NSLog(@"请求错误");
                
            } showHUD:nil];
        }];
    }else if (btn.tag==1) {
        [[HWPopTool sharedInstance] closeWithBlcok:^{
            NSString *token=[NSString stringWithFormat:@"%@",self.token];
            //NSString *url=@"/pay/pay_weixin_app/price/50/pid/0/hb/1";
            NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
            mDic[@"price"] = @"50";
            mDic[@"pid"] = @"0";
            mDic[@"hb"] = @"1";
            
            [CKHttpCommunicate createTokenRequest:HTTP_WX withToken:token WithParam:mDic withMethod:POST success:^(id result) {
                NSLog(@"$$$$$$$$$______%@",result);
                NSMutableDictionary *data = result[@"data"];
                [self bizPay:data];
            } failure:^(NSError *erro) {
                NSLog(@"请求错误");
            } showHUD:nil];
            
            
        }];
    }else if (btn.tag==2) {
        [[HWPopTool sharedInstance] closeWithBlcok:^{
            
            // NSString *url=@"/pay/pay_weixin_app/price/10/pid/0/hb/1";
            NSString *token=[NSString stringWithFormat:@"%@",self.token];
            NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
            mDic[@"price"] = @"10";
            mDic[@"pid"] = @"0";
            mDic[@"hb"] = @"1";
            
            [CKHttpCommunicate createTokenRequest:HTTP_WX withToken:token WithParam:mDic withMethod:POST success:^(id result) {
                NSLog(@"$$$$$$$$$______%@",result);
                NSMutableDictionary *data = result[@"data"];
                [self bizPay:data];
            } failure:^(NSError *erro) {
                NSLog(@"请求错误");
            } showHUD:nil];
            
            
        }];
    }else if (btn.tag==3) {
        [[HWPopTool sharedInstance] closeWithBlcok:^{
            
            // NSString *url=@"/pay/pay_weixin_app/price/1/pid/0/hb/1";
            NSString *token=[NSString stringWithFormat:@"%@",self.token];
            NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
            mDic[@"price"] = @"1";
            mDic[@"pid"] = @"0";
            mDic[@"hb"] = @"1";
            
            [CKHttpCommunicate createTokenRequest:HTTP_WX withToken:token WithParam:mDic withMethod:POST success:^(id result) {
                NSLog(@"$$$$$$$$$______%@",result);
                NSMutableDictionary *data = result[@"data"];
                [self bizPay:data];
            } failure:^(NSError *erro) {
                NSLog(@"请求错误");
                
            } showHUD:nil];
            
            
        }];
    }
}
- (void)bizPay:(NSMutableDictionary *)dict {
    NSString *res = [WXApiRequestHandler jumpToBizPay:dict];
    

    if( ![@"" isEqual:res] ){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }
//    else{
//        [FormValidator showAlertWithStr:@"恭喜您，充值成功！                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            "];
//    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
