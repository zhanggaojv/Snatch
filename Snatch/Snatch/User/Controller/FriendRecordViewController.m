//
//  FriendRecordViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/6.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "FriendRecordViewController.h"

@interface FriendRecordViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) UIWebView *web;

@end

@implementation FriendRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBarButtonItem];
    [self addWebViewUI];
    
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
    if ([self.web canGoBack]) {
        [self.web goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_BASE,self.Url]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    NSMutableURLRequest *mutableRequest=[request mutableCopy];
    [mutableRequest setHTTPMethod: @"GET"];
    [mutableRequest addValue:@"3" forHTTPHeaderField:@"device"];
    [mutableRequest addValue:self.token forHTTPHeaderField:@"token"];
    request=[mutableRequest copy];
    [web loadRequest: request];
    self.web = web;
    
    
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
    
    NSLog(@"页面跳转");
    
    
    return YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
