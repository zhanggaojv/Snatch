//
//  AppDelegate.m
//  Snatch
//
//  Created by Zhanggaoju on 16/9/21.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "AppDelegate.h"

#import "UITabBarController+Extension.h"

#import "GuidePageViewController.h"
#import "SnatchViewController.h"
#import "AnnounceViewController.h"
#import "ActivitiesViewController.h"
#import "BillViewController.h"
#import "UserViewController.h"
#import "LoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>

#import "GJTokenManager.h"
#import "WXApiManager.h"

#import "SPayClient.h"

#import "QJPaySDK.h"

#import "CoreJPush.h"

@interface AppDelegate ()<WXApiDelegate>

@property (nonatomic , strong)UIViewController *snatchVC;
@property (nonatomic , strong)UIViewController *announceVC;
@property (nonatomic , strong)UIViewController *activitiesVC;
@property (nonatomic , strong)UIViewController *billVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //注册JPush
    [CoreJPush registerJPush:launchOptions];

    //  SDK版本信息
    NSLog(@"版本号：%@",[SPayClient sharedInstance].spaySDKVersion);
    NSLog(@"版本类型：%@",[SPayClient sharedInstance].spaySDKTypeName);
    NSLog(@"ios版本：%@",[[UIDevice currentDevice] systemVersion]);
    NSLog(@"设备模式：%@",[[UIDevice currentDevice] model]);
    SPayClientWechatConfigModel *wechatConfigModel = [[SPayClientWechatConfigModel alloc] init];
    wechatConfigModel.appScheme = @"wxfd7e82330b594dbd";
    wechatConfigModel.wechatAppid = @"wxfd7e82330b594dbd";
    
    //配置微信APP支付
    [[SPayClient sharedInstance] wechatpPayConfig:wechatConfigModel];
    
    [[SPayClient sharedInstance] application:application
               didFinishLaunchingWithOptions:launchOptions];

    
    
    //向微信注册
    [WXApi registerApp:kAppId withDescription:@"夺你所爱"];
    
    [MobClick setLogEnabled:YES];
    [MobClick setAppVersion:XcodeAppVersion];

    

    [MobClick setLogEnabled:YES];
    //打开日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57fda7a867e58ec68000186b"];
        // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    NSString *version=@"1.5";
    [MobClick setAppVersion:version];
    
    //各平台的详细配置
    //设置微信的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kAppId appSecret:kAppSecret redirectURL:@"http://www.duonisuoai.com"];
    
    //设置分享到QQ互联的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppId  appSecret:nil redirectURL:@"http://www.duonisuoai.com"];
    
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    self.window.backgroundColor=[UIColor whiteColor];
    
    BOOL ret = [[[NSUserDefaults standardUserDefaults] objectForKey:@"GUIDE_STATUS"] boolValue];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoView:) name:@"userViewGoto" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setWindowRootViewController) name:@"loginViewGoto" object:nil];
    
    if (ret == YES) {
        //引导页出现过了
        [self setWindowRootViewController];
    }else{

        self.window.rootViewController =[[GuidePageViewController alloc]init];
    }
    
//    //检测是不是无网状态或者飞行模式
//    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
//    // 开始监控
//    [mgr startMonitoring];
//    if (mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable) {
//        
//        
//        [self GetlineSYS];
//    }   
    //初始化
    Reachability *reachability=[Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
            
        case NotReachable:
           
            break;
        case ReachableViaWiFi:
            [self GetlineSYS];
            break;
        case ReachableViaWWAN:
            [self GetlineSYS];
            break;
    }
    
    return YES;
    
}
/**
 *获取版本信息
 */
-(void)GetlineSYS{
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
             NSLog(@"线上版本号：%@",_version);
            [self HTTP_GetSystemInfo:_version];
      }
        
    }];
    [dataTask resume];
    
    
}
-(void)HTTP_GetSystemInfo:(NSString *)version{
    if ([GJTokenManager hasAvalibleToken]) {
        self.token=[GJTokenManager accessToken];
        NSLog(@"––––––––––––%@",self.token);
    }
    
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    [CKHttpCommunicate createTokenRequest:HTTP_GetSystemInfo withToken:token WithParam:nil withMethod:POST success:^(id result) {
        NSLog(@"33____result:%@",result);
        _SystemInfoData=result[@"data"];
        
        NSUserDefaults *newver=[NSUserDefaults standardUserDefaults];
        [newver setObject:_SystemInfoData[@"newver1"] forKey:@"newver"];
        
        NSString * localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"本地版本号：%@",localVersion);
        /*
         因版本号形式为1.0.0、2.1.0等样式，为了便于比较，执行字符串操作，将字符串中的点换为空
         例如线上版本为2.1.0 本地版本为2.0.0
         进行对应转化后即可变为210与200，如此进行比较会更方便。
         */
        NSString * online = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
        
//        NSString * local = [localVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSLog(@"%d",[online intValue]);
        if ([online intValue]>15) {
            NSLog(@"有新版本");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNotification" object:nil userInfo:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateClick) name:@"updateNotification" object:nil];
}
-(void)updateClick
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *newver = [userDefault objectForKey:@"newver"];
    
    
    if (IFNEWVER) {
    AlertView *alertView = [[AlertView alloc]initWithTitle:[NSString stringWithFormat:@"您有最新版本可以更新！"] andMessage:@"现在去更新"] ;
    [alertView addButtonWithTitle:@"取消" type:CustomAlertViewButtonTypeDefault handler:nil];
    [alertView addButtonWithTitle:@"确定" type:CustomAlertViewButtonTypeCancel handler:^(AlertView *alertView) {
        [self updateSystemInfo];
    }];
    alertView.transitionStyle = CustomAlertViewTransitionStyleBounce;
    [alertView show];
    }
}

-(void)updateSystemInfo{
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/app/id1144374028"];
    [[UIApplication sharedApplication] openURL:url];
    
}

/**
 *设置跟视图控制器
 */
-(void)setWindowRootViewController{
    
    _tab=[[UITabBarController alloc]init];
    
    SnatchViewController *snatch=[[SnatchViewController alloc]init];
    [_tab addViewController:snatch title:@"夺宝" imageName:@"duobao_normal" seleteImageName:@"duobao_selected"];
    _snatchVC = snatch;
    
    AnnounceViewController *announce=[[AnnounceViewController alloc]init];
    [_tab addViewController:announce title:@"最近揭晓" imageName:@"zuixinjiexiao_normal" seleteImageName:@"zuixinjiexiao_selected"];
    _announceVC = announce;
    
    ActivitiesViewController *activities=[[ActivitiesViewController alloc]init];
    [_tab addViewController:activities title:@"活动" imageName:@"huodong_normal" seleteImageName:@"huodong_selected"];
    _activitiesVC = activities;
    BillViewController*bill=[[BillViewController alloc]init];
    [_tab addViewController:bill title:@"晒单" imageName:@"shaidan_normal" seleteImageName:@"shaidan_selected"];
    _billVC = bill;
    if(![GJTokenManager hasAvalibleToken]){
    LoginViewController *login=[[LoginViewController alloc]init];
    [_tab addViewController:login title:@"个人中心" imageName:@"wode_normal" seleteImageName:@"wode_selected"];
    }else{
    UserViewController *user=[[UserViewController alloc]init];
    [_tab addViewController:user title:@"个人中心" imageName:@"wode_normal" seleteImageName:@"wode_selected"];
    }
    
    _tab.tabBar.tintColor=kDefaultColor;
    
    //tab.tabBar.tintColor = SELECT_COLOR(250, 20, 50, 1);
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.self.window.rootViewController = delegate.tab;
    
}
-(void)gotoView:(NSNotification *)notification{
    _tab=[[UITabBarController alloc]init];
    
    [_tab addViewController:_snatchVC title:@"夺宝" imageName:@"duobao_normal" seleteImageName:@"duobao_selected"];
    
    [_tab addViewController:_announceVC title:@"最近揭晓" imageName:@"zuixinjiexiao_normal" seleteImageName:@"zuixinjiexiao_selected"];
    
    [_tab addViewController:_activitiesVC title:@"活动" imageName:@"huodong_normal" seleteImageName:@"huodong_selected"];
    
    [_tab addViewController:_billVC title:@"晒单" imageName:@"shaidan_normal" seleteImageName:@"shaidan_selected"];
    
    UserViewController *user=[[UserViewController alloc]init];
    [_tab addViewController:user title:@"个人中心" imageName:@"wode_normal" seleteImageName:@"wode_selected"];
    _tab.tabBar.tintColor=kDefaultColor;
    _tab.selectedIndex = 4;
    //tab.tabBar.tintColor = SELECT_COLOR(250, 20, 50, 1);
//    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    self.window.rootViewController = _tab;
    user.token=notification.userInfo[@"token"];
}

 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{

    
    if([[url absoluteString] rangeOfString:@"wxfd7e82330b594dbd://pay"].location == 0) //你的微信开发者appid
        
      // return  [QJPaySDK handleOpenWeChatURL:url];
      return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
     //  return  [[SPayClient sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    else
        return [[UMSocialManager defaultManager] handleOpenURL:url];

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url]||[WXApi handleOpenURL:url delegate:self];
//    if (!result) {
//        
//    }
//    return result;
    if([[url absoluteString] rangeOfString:@"wxfd7e82330b594dbd://pay"].location == 0) //你的微信开发者appid
     //   return [QJPaySDK handleOpenWeChatURL:url];
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
       // return  [[SPayClient sharedInstance] application:application handleOpenURL:url];
    else
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    
}
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
//    
//    [QJPaySDK handleOpenWeChatURL:url];
//    return [QJPaySDK handleOpenURL:url];
//
//}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}
- (void)applicationWillEnterForeground:(UIApplication *)application {
   
//[[SPayClient sharedInstance] applicationWillEnterForeground:application];
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
   // [[NSNotificationCenter defaultCenter] postNotificationName: [QJPaySDK WETCHAR] object:nil];
}
- (void)applicationWillTerminate:(UIApplication *)application {

}

//
//#pragma mark - Core Data stack
//
//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//
//- (NSURL *)applicationDocumentsDirectory {
//    // The directory the application uses to store the Core Data store file. This code uses a directory named "ryhui.FormCommit" in the application's documents directory.
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//- (NSManagedObjectModel *)managedObjectModel {
//    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FormCommit" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    // Create the coordinator and store
//    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FormCommit.sqlite"];
//    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}
//
//
//- (NSManagedObjectContext *)managedObjectContext {
//    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (!coordinator) {
//        return nil;
//    }
//    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    return _managedObjectContext;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext {
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        NSError *error = nil;
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}

@end
