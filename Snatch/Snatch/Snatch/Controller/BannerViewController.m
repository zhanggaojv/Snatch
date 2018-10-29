//
//  BannerViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 16/9/30.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "BannerViewController.h"
#import "BalanceViewController.h"
#import "UMSocialUIManager.h"

#import "JSONStrToDict.h"
#import "WXApiRequestHandler.h"

@interface BannerViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) UIWebView *web;
@property ( nonatomic) BOOL isback;
@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBarButtonItem];
    [self addWebViewUI];
}


-(void)addWebViewUI{
  
    
    if ([GJTokenManager hasAvalibleToken]) {
        self.token=[GJTokenManager accessToken];
        NSLog(@"––––––––––––%@",self.token);
    }
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    web.delegate = self;
    
    web.scalesPageToFit =YES;
    
    web.scrollView.delegate = self;
    
    
    [self.view addSubview:web];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.BannerUrl]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    NSMutableURLRequest *mutableRequest=[request mutableCopy];
    [mutableRequest setHTTPMethod: @"GET"];
    [mutableRequest addValue:@"3" forHTTPHeaderField:@"device"];
    [mutableRequest addValue:self.token forHTTPHeaderField:@"token"];
    [mutableRequest addValue:NEWAPPVALUE forHTTPHeaderField:@"newapp"];
    request=[mutableRequest copy];
    [web loadRequest: request];
    self.web = web;

    
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
    _isback=YES;
    
    if ([self.web canGoBack]) {
        [self.web goBack];
    }else{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SHttpRequest" object:nil userInfo:nil];
        [self.navigationController popViewControllerAnimated:YES];
        _isback=NO;
        
    }
    
}

- (void)Rback {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark ---Delegate
-(void) webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"开始加载－－－") ;
    
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"加载完成－－－");
    
    //获取当前页面的title
    NSString *title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"title====%@",title);
    self.title=title;

    //获取当前URL
    NSString *URL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"URL===%@",URL);
    
    
    //得到网页代码
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML" ];
    NSLog(@"html====%@",html);

    
    _dataStr = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('UserInfo')[0].value"];
    NSLog(@"____pinfo====%@",_dataStr);
    //转化为data
    NSData *jsonData = [_dataStr dataUsingEncoding:NSUTF8StringEncoding];
    //转化为字典
    _data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"data========%@",_data);

    
    //拼接字符串 根据网页name找到控价并赋值
    NSString *str = @"随_的简书";
    NSString *JSStr = [NSString stringWithFormat:@"document.getElementsByName('q')[0].value = ('%@');",str];
    [webView stringByEvaluatingJavaScriptFromString:JSStr];
    
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"加载失败＝＝＝%@",error);
    
    
}


//当网页位置为顶部 不允许继续下拉
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.web.frame.origin.y == 0) {
        
        self.web.scrollView.bounces = NO;
        
        return;
        
    }
    
}


//webView的每次页面跳转都会执行，在这里可以得到想要的数据
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [NSString stringWithString:[request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",url);
    
    NSLog(@"webviewwwwwww%@", request.allHTTPHeaderFields);
    
    if([@"bridge" isEqualToString:[url substringToIndex:6]]){
        NSArray *array = [url componentsSeparatedByString:@"data="];
        NSArray *array1 = [url componentsSeparatedByString:@"code="];
        NSString *code = [array1[1] substringToIndex:15];
        
        
        if([code containsString:@"wxpayApp"]){//需要跳转支付
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            NSString *newver = [userDefault objectForKey:@"newver"];
            
            if (IFNEWVER) {//跳转到充值页面
                NSString *json = array[1];
                NSDictionary *dic = [JSONStrToDict dictionaryWithJsonString:json];
                NSLog(@"dic______%@",dic);
                NSMutableDictionary *data=dic[@"data"];
                NSLog(@"data______%@",data);
                    //[self bizPay:data];
                [self SPay:data];
                
            }
        }
        else if ([code containsString:@"wxShareApp"])
        {
            NSString *json = array[1];
            NSDictionary *dic = [JSONStrToDict dictionaryWithJsonString:json];
            _titles = [dic objectForKey:@"title"];
            NSLog(@" %@",_titles);
            
            NSString *jsonlink = array[1];
            NSDictionary *diclink = [JSONStrToDict dictionaryWithJsonString:jsonlink];
            _link = [diclink objectForKey:@"link"];
            NSLog(@" %@",_link);
            
            NSString *jsonimageurl = array[1];
            NSDictionary *dicurl = [JSONStrToDict dictionaryWithJsonString:jsonimageurl];
            _imageurl = [dicurl objectForKey:@"imgUrl"];
            NSLog(@" %@",_imageurl);
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            NSString *newver = [userDefault objectForKey:@"newver"];
            
            
            if (IFNEWVER) {
                
                //显示分享面板
                
                [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
                    
                    [self shareWebPageToPlatformType:platformType];
                }];
            }
        }return YES;
    }else{
        BOOL headerIsPresent = [[request allHTTPHeaderFields] objectForKey:@"device"]!=nil;
        if(headerIsPresent || _isback==YES){
            _isback=NO;
            return YES;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL *url = [request URL];
                
                NSString *token=[GJTokenManager accessToken];
                NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                [request  addValue:@"3" forHTTPHeaderField:@"device"];
                [request  addValue:token forHTTPHeaderField:@"token"];
                [request  addValue:NEWAPPVALUE forHTTPHeaderField:@"newapp"];
                NSLog(@"页面跳转 ---");
                // reload the request
                [self.web  loadRequest:request];
                
            });
        });
        
    }
    return NO;
    
}
-(void)SPay:(NSMutableDictionary *)wxData{
    // 调起SPaySDK支付
    [[SPayClient sharedInstance] pay:self
                              amount:wxData[@"key"]
                   spayTokenIDString:wxData[@"token_id"]
                   payServicesString:@"pay.weixin.app"
                              finish:^(SPayClientPayStateModel *payStateModel,
                                       SPayClientPaySuccessDetailModel *paySuccessDetailModel) {
                                  
                                  //更新订单号
                                  //self.out_trade_noText.text = wxData[@"sign"];
                                  
                                  
                                  if (payStateModel.payState == SPayClientConstEnumPaySuccess) {
                                      
                                      NSLog(@"支付成功");
                                      NSLog(@"支付订单详情-->>\n%@",[paySuccessDetailModel description]);
                                  }else{
                                      NSLog(@"支付失败，错误号:%d",payStateModel.payState);
                                  }
                                  
                              }];
    
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
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_titles descr:nil thumImage:_imageurl];
    //设置网页地址
    shareObject.webpageUrl =_link;
    
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

@end
