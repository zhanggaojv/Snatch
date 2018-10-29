//
//  JDPayViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/11/24.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "JDPayViewController.h"
#import "AFNetworking.h"


@interface JDPayViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *web;
@end

@implementation JDPayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBarButtonItem];
    
    _web = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _web.delegate = self;
    
    _web.scalesPageToFit =YES;
    
    [self.view addSubview:_web];

    self.token=[GJTokenManager accessToken];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"price"] = _price;
    mDic[@"pid"] = _pid;
    mDic[@"hbid"]=_hbid;
    if ([_queue intValue]!=1) {
        mDic[@"queue"] = [NSString stringWithFormat:@"%@",_queue];
    }
    NSDictionary *dic=@{@"code":@"playjdapp",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jData withMethod:POST success:^(id result) {
        NSLog(@"55%@",result);
        NSDictionary *dic=result[@"data"];
        [self payJDApp:dic];
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
    
    if ([self.web canGoBack]) {
        [self.web goBack];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)Rback {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)payJDApp:(NSDictionary *)dic{
    
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    //[mgr.securityPolicy setAllowInvalidCertificates:YES];
    mgr.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"text/javascript",nil];
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [mgr POST:@"https://h5pay.jd.com/jdpay/saveOrder" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求成功responseObject--%@",responseObject);
            
            NSString *htmlstring=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
            //将第二次请求出来的html字符串加载到webview
            [_web loadHTMLString:htmlstring baseURL:[NSURL URLWithString:@"https://h5pay.jd.com/jdpay/saveOrder"]];
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
               NSLog(@"请求失败error--%@",error);
    }];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    //获取当前页面的title
    NSString *title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"title====%@",title);
    self.title=title;
 
    NSLog(@"=============%@",webView.request.URL);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_web resignFirstResponder];
}

//webView的每次页面跳转都会执行，在这里可以得到想要的数据
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = [NSString stringWithString:[request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",url);
    
    NSLog(@"webviewwwwwww%@", request.allHTTPHeaderFields);
    
    if([@"bridge" isEqualToString:[url substringToIndex:6]]){
        NSArray *array1 = [url componentsSeparatedByString:@"code="];
        NSString *code = [array1[1] substringToIndex:16];
        if([code containsString:@"testObjcCallback"]){//需要跳转页面
            //            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginViewGoto" object:nil userInfo:nil];
        }
    }
    NSLog(@"页面跳转");
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
