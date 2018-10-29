//
//  SettingViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/9.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "SettingMenuData.h"
#import "AddressViewController.h"
#import "PhoneViewController.h"
#import "GJTokenManager.h"
#import "LoginViewController.h"
#import "QuestionViewController.h"
#import "GuanyuViewController.h"
#import "LainxiViewController.h"
#import "WentiViewController.h"

#import "PopupView.h"
#import "LewPopupViewAnimationSlide.h"
#import "SnatchViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) SettingMenuData *menuData;

@property (strong, nonatomic) UIView *contentView;

@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCache];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self addUserTableVIewUI];
    [self addBarButtonItem];
    [self HTTP_GetSystemInfo];
    
}
//获取版本信息
-(void)HTTP_GetSystemInfo{
    if ([GJTokenManager hasAvalibleToken]) {
        self.token=[GJTokenManager accessToken];
        NSLog(@"––––––––––––%@",self.token);
    }
    
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    [CKHttpCommunicate createTokenRequest:HTTP_GetSystemInfo withToken:token WithParam:nil withMethod:POST success:^(id result) {
        NSLog(@"33____result:%@",result);
        _SystemInfoData=result[@"data"];
        
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

/**
 *  布局UI界面
 */
-(void)addUserTableVIewUI{
    self.title=@"设置";
    UIImage* image= [UIImage imageNamed:@"backButton"];
    CGRect frame= CGRectMake(0, 0, 20, 20);
    UIButton *someButton= [[UIButton alloc] initWithFrame:frame];
    [someButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton setShowsTouchWhenHighlighted:YES];
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    _menuData=[[SettingMenuData alloc]init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-120) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setShowsVerticalScrollIndicator:YES];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO; // 设置为不可滚动
    [self.view addSubview:_tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;//防止下沉
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footerView.backgroundColor=self.view.backgroundColor;
    self.tableView.tableFooterView=footerView;
    UIButton *logoutBtn=[[UIButton alloc]init];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutTip) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.titleLabel.font=SYSTEM_FONT(15);
    logoutBtn.backgroundColor=kDefaultColor;
    logoutBtn.layer.cornerRadius =4;
    logoutBtn.layer.masksToBounds =YES;
    logoutBtn.layer.rasterizationScale =kScreenScale;
    [footerView addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(footerView.mas_bottom);
        make.centerX.mas_equalTo(footerView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(220, 40));
    }];
    [self getLoneSysVersion];
}
-(void)getLoneSysVersion{
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/CN/lookup?id=1144374028"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //5.解析数据
        NSMutableDictionary *sysDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"0-0%@",sysDict);
        NSLog(@"9-9%@",sysDict[@"results"]);
        for (NSMutableDictionary *dic in sysDict[@"results"]) {
            NSLog(@"9-9%@",dic[@"version"]);
            _version=dic[@"version"];
            
        }
        
    }];
    
    [dataTask resume];
}
-(void)logoutTip{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:_contentView.bounds];
    imageV.image=[UIImage imageNamed:@"tc"];
    [_contentView addSubview:imageV];
    
    UIButton *notcBtn=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-90*2-10)/2, SCREEN_HEIGHT/2, 90, 40)];
    [notcBtn setImage:[UIImage imageNamed:@"notc"] forState:UIControlStateNormal];
    //notcBtn.backgroundColor=[UIColor redColor];
    [notcBtn addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:notcBtn];
    
    UIButton *yesBtn=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-90*2-10)/2+100, SCREEN_HEIGHT/2, 90, 40)];
    [yesBtn setImage:[UIImage imageNamed:@"yestc"] forState:UIControlStateNormal];
    //yesBtn.backgroundColor=[UIColor blueColor];
    [yesBtn addTarget:self action:@selector(yesAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:yesBtn];
    
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:YES];
    
}
-(void)noAction{
    [[HWPopTool sharedInstance] closeWithBlcok:^{
       [[NSNotificationCenter defaultCenter]postNotificationName:@"loginViewGoto" object:nil userInfo:nil];
    }];
}
-(void)yesAction{
    [[HWPopTool sharedInstance] closeWithBlcok:^{
    [self logoutAction];
    }];
}
-(void)logoutAction{
    NSLog(@"退出登录");
   
     [MobClick profileSignOff];
    if ([GJTokenManager hasAvalibleToken]) {
        self.token=[GJTokenManager accessToken];
        NSLog(@"––––––––––––%@",self.token);
    }
    
    NSDictionary *dic=@{@"code":@"logOut"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jsondata withMethod:POST success:^(id result) {
        NSLog(@"______________result:%@",result);
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:nil];
    
    [GJTokenManager removelibleToken];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginViewGoto" object:nil userInfo:dic];
    
}
//返回
- (void) back {
    
    [self.navigationController popViewControllerAnimated:YES];
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
    static NSString *cellIdentifier=@"SettingCell";
    SettingCell *userCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!userCell) {
        userCell=[[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0: {
                
                userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 1: {
                userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 2: {
                userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            default:
            break;
        }
    }

    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0: {
                
                UILabel *Cache=[[UILabel alloc]initWithFrame:CGRectMake(self.view.width-160, (userCell.height-50)/2, 150, 50)];
                Cache.text=[NSString stringWithFormat:@"%.2lfKB",_cacheSize];
                Cache.textColor=[UIColor lightSeaGreen];
                Cache.font=[UIFont systemFontOfSize:14];
                Cache.textAlignment=NSTextAlignmentRight;
                [userCell addSubview:Cache];
            }
                break;
            case 1: {
                //        NSString * localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
                UILabel *versionName=[[UILabel alloc]initWithFrame:CGRectMake(self.view.width-50, (userCell.height-50)/2, 40, 50)];
                //versionName.text=[NSString stringWithFormat:@"%@",localVersion];
                versionName.text=@"1.4";
                versionName.textAlignment=NSTextAlignmentRight;
                versionName.textColor=[UIColor lightSeaGreen];
                versionName.font=[UIFont systemFontOfSize:14];
                [userCell addSubview:versionName];
            }
         }
    }
    userCell.menuLabel.text=self.menuData.textData[indexPath.section][indexPath.row];
    userCell.layer.masksToBounds=YES;
    userCell.layer.cornerRadius=1;
    userCell.layer.borderWidth=1;
    userCell.layer.borderColor=[UIColor whiteSmoke].CGColor;
    userCell.backgroundColor=[UIColor whiteColor];
    
    return userCell;
    
}

////设置表头高度
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 15.0f;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0: {
                self.hidesBottomBarWhenPushed=YES;
                GuanyuViewController *guanyu=[[GuanyuViewController alloc]init];
                [self.navigationController pushViewController:guanyu animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
                break;
            case 1: {
                self.hidesBottomBarWhenPushed=YES;
                LainxiViewController *lx=[[LainxiViewController alloc]init];
                [self.navigationController pushViewController:lx animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
                break;
            case 2: {
                self.hidesBottomBarWhenPushed=YES;
                WentiViewController *wt=[[WentiViewController alloc]init];
                [self.navigationController pushViewController:wt animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
                break;
                
            default:
                break;
        }
    }
  
    if (indexPath.section==1) {
        switch (indexPath.row) {
    case 0: {
        if (_cacheSize>0) {
        AlertView *alertView = [[AlertView alloc]initWithTitle:[NSString stringWithFormat:@"缓存数据共计%@",_cacheSizeStr] andMessage:@"清除缓存"] ;
        [alertView addButtonWithTitle:@"取消" type:CustomAlertViewButtonTypeDefault handler:nil];
        [alertView addButtonWithTitle:@"确定" type:CustomAlertViewButtonTypeCancel handler:^(AlertView *alertView) {
            BOOL result = [XHNetworkCache clearCache];
            if(result) NSLog(@"缓存清除成功!");
             [self getCache];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
            });
            
        }];
        alertView.transitionStyle = CustomAlertViewTransitionStyleBounce;
        [alertView show];
        }else{
            [Alert show:@"亲，让你白来了一趟，暂无缓存哦！" hasSuccessIcon:NO AndShowInView:_tableView];
        }
       

    }
        break;
    case 1: {
        [self checkAppUpdate:_version];
    }
        }
       
    }
    
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
    
}
- (void)getCache{
    NSString *path = [XHNetworkCache cachePath];
    NSLog(@"path=%@",path);
    _cacheSize = [XHNetworkCache cacheSize];
    NSLog(@"缓存大小:%f M",_cacheSize);
     _cacheSizeStr=[NSString stringWithFormat:@"%.2lfM",_cacheSize];
    if (_cacheSize<1) {
        _cacheSize=_cacheSize*1024;
        _cacheSizeStr=[NSString stringWithFormat:@"%.2lfKB",_cacheSize];
    }
    
}

- (void)checkAppUpdate:(NSString *)onlineVersion{
    NSString * localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"本地版本号：%@",localVersion);
    /*
     因版本号形式为1.0.0、2.1.0等样式，为了便于比较，执行字符串操作，将字符串中的点换为空
     例如线上版本为2.1.0 本地版本为2.0.0
     进行对应转化后即可变为210与200，如此进行比较会更方便。
     */
    NSString * online = [onlineVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    //NSString * local = [localVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([online intValue]>15) {
        NSLog(@"有新版本");
        [self updateClickBtn];
        
    }else{
        NSLog(@"已是最新版本");
        [self notUpdateClickBtn];
    }
}
-(void)updateClickBtn
{
    AlertView *alertView = [[AlertView alloc]initWithTitle:[NSString stringWithFormat:@"最新版本为%@",_version] andMessage:@"现在去更新"] ;
    [alertView addButtonWithTitle:@"取消" type:CustomAlertViewButtonTypeDefault handler:nil];
    [alertView addButtonWithTitle:@"确定" type:CustomAlertViewButtonTypeCancel handler:^(AlertView *alertView) {
        [self updateSystemInfo];
    }];
    alertView.transitionStyle = CustomAlertViewTransitionStyleBounce;
    [alertView show];
}
-(void)updateSystemInfo{
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/app/id1144374028"];
    [[UIApplication sharedApplication] openURL:url];
}
-(void)notUpdateClickBtn
{
   
    [Alert show:@"已是最新版本" hasSuccessIcon:YES AndShowInView:_tableView];
}
//点击后，过段时间cell自动取消选中
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
