//
//  UserInfoViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/7.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UploadAvatarViewController.h"

@interface UserInfoViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) UIWebView *web;
@property ( nonatomic) BOOL isback;
@end

@implementation UserInfoViewController
-(void)viewWillAppear:(BOOL)animated{
   [_web.scrollView.mj_header beginRefreshing];

}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self addWebViewUI];
    [self addBarButtonItem];
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
        
        [self.navigationController popViewControllerAnimated:YES];
        _isback=NO;
        
    }
    
}

- (void)Rback {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_BASE,self.userUrl]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    NSMutableURLRequest *mutableRequest=[request mutableCopy];
    [mutableRequest setHTTPMethod: @"GET"];
    [mutableRequest addValue:@"3" forHTTPHeaderField:@"device"];
    [mutableRequest addValue:self.token forHTTPHeaderField:@"token"];
    [mutableRequest  addValue:NEWAPPVALUE forHTTPHeaderField:@"newapp"];
    request=[mutableRequest copy];
    [web loadRequest: request];
    self.web = web;
    //添加下拉刷新
    self.web.scrollView.mj_header = [GJRefreshHeader headerWithRefreshingBlock:^{
        [self.web reload];
    [_web.scrollView.mj_header endRefreshing];
   
    }];
    
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
    
//    if (self.web.frame.origin.y == 0) {
//        
//        self.web.scrollView.bounces = NO;
//        
//        return;
//        
//    }
    
}


//webView的每次页面跳转都会执行，在这里可以得到想要的数据
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = [NSString stringWithString:[request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",url);
    
    NSLog(@"webviewwwwwww%@", request.allHTTPHeaderFields);
    
    if([@"bridge" isEqualToString:[url substringToIndex:6]]){
        NSArray *array1 = [url componentsSeparatedByString:@"code="];
        NSString *code = [array1[1] substringToIndex:15];
        if([code containsString:@"headLogo"]){//需要跳转页面
            UploadAvatarViewController *pub=[[UploadAvatarViewController alloc]init];
            [self.navigationController pushViewController:pub animated:YES];
        }
        return YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
