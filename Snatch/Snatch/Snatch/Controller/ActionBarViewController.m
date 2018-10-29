//
//  ActionBarViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 16/9/30.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "ActionBarViewController.h"
#import "LoginViewController.h"
#import "BalanceViewController.h"
#import "UMSocialUIManager.h"
#import "PayViewController.h"

@interface ActionBarViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) UIWebView *web;
@property ( nonatomic) BOOL isback;
@end

@implementation ActionBarViewController
//-(void)viewWillAppear:(BOOL)animated{
//    [_web reload];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addWebViewUI];
    [self addBarButtonItem];
    //注册监听键盘的通知
    [[NSNotificationCenter
      defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:)
     name:UIKeyboardWillChangeFrameNotification object:nil];
    
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
    UIWebView *web = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    NSString *url=[NSString stringWithFormat:@"%@/%@",URL_BASE,self.ActionBarUrl];
    
    
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    web.delegate = self;
    
    web.scalesPageToFit =YES;
    
    web.scrollView.delegate = self;
    
    self.web = web;
    
    [self.view addSubview:web];
    
    
    
}
-(void)addShoppingCartUI{
    _carView=[[UIView alloc]init];
    _carView.backgroundColor=[UIColor whiteSmoke];
    [self.web addSubview:_carView];
    [_carView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 160));
    }];
    
    [self.web bringSubviewToFront:_carView];
    
    [self GJShoppingCartBtn];

}
-(void)GJShoppingCartBtn{
    [self setupBtn];
    
    _cartBtn = [[GJShoppingCartBtn alloc]initWithFrame:CGRectMake((self.view.width-300)/2, 20, 300, 40)];
    //开启抖动动画
    _cartBtn.shakeAnimation = YES;
    _cartBtn.borderColor=[UIColor grayColor];
    _cartBtn.numberBlock = ^(NSString *num){
        // NSLog(@"%@",num);
        _number=num;
    };
    [_carView addSubview:_cartBtn];
    
    
    
    _goPayBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.width-300)/2, 110, 300, 40)];
    _goPayBtn.titleLabel.font=SYSTEM_FONT(14);
    _goPayBtn.backgroundColor=kDefaultColor;
    _goPayBtn.layer.cornerRadius =4;
    _goPayBtn.layer.masksToBounds =YES;
    _goPayBtn.layer.rasterizationScale =kScreenScale;
    [_carView addSubview:_goPayBtn];
    [_goPayBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_goPayBtn addTarget:self action:@selector(goPayBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)setupBtn {
    for (int i = 0; i < 4; i++) {
        UIButton *abBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        abBtn.layer.borderWidth=1;
        abBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        abBtn.backgroundColor=[UIColor whiteColor];
        abBtn.layer.masksToBounds=YES;
        abBtn.layer.cornerRadius=3;
        [abBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        abBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        abBtn.tag = i;
        switch (i) {
            case 0:
            {
                [abBtn setTitle:@"30" forState:UIControlStateNormal];
                
            }
                break;
            case 1:
            {
                [abBtn setTitle:@"50" forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [abBtn setTitle:@"100" forState:UIControlStateNormal];
            }
                break;
            case 3:
            {
                [abBtn setTitle:@"包尾" forState:UIControlStateNormal];
                NSLog(@"_cartBtn.textField.text=======%@",_data[@"surplus"]);
            }
                break;
                
                
            default:
                break;
        }
        
        int col = i % 4;
        abBtn.x = col * (60 + 10)+(self.view.width-270)/2;
        int row = i / 4;
        abBtn.y = row * (20 + 10)+70;
        [_carView addSubview:abBtn];
        [abBtn addTarget:self action:@selector(charge:) forControlEvents:UIControlEventTouchUpInside];

    }
}
-(void)charge:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
            _cartBtn.textField.text=sender.titleLabel.text;
            _number=sender.titleLabel.text;
            
        }
            break;
        case 1:
        {
            _cartBtn.textField.text=sender.titleLabel.text;
            _number=sender.titleLabel.text;
        }
            break;
        case 2:
        {
            _cartBtn.textField.text=sender.titleLabel.text;
            _number=sender.titleLabel.text;
        }
            break;
        case 3:
        {
            _cartBtn.textField.text=[NSString stringWithFormat:@"%@",_data[@"surplus"]];
            _number=[NSString stringWithFormat:@"%@",_data[@"surplus"]];
            
        }
            break;
            
            
        default:
            break;
    }
    
    
}
-(void)goPayBtnAction{
    _queue=[_data[@"queue"] intValue];
    if (_queue>1) {
        NSString *queuedataStr = [_web stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('queue')[0].value"];
        NSLog(@"____queue======%@",queuedataStr);
        //转化为data
        NSData *queueJsonData = [_dataStr dataUsingEncoding:NSUTF8StringEncoding];
        //转化为字典
        _Qdata = [NSJSONSerialization JSONObjectWithData:queueJsonData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"Qdata==========%@",_Qdata);
        _value=queuedataStr;
    }

    
    
    
    [self sendMess];
    
    if ([GJTokenManager hasAvalibleToken]) {
        self.token=[GJTokenManager accessToken];
        NSLog(@"––––––––––––%@",self.token);
    }
    

    if (![GJTokenManager hasAvalibleToken]) {
        LoginViewController *login=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }else if ([_data[@"surplus"] intValue]<1) {
        [FormValidator showAlertWithStr:@"没有剩余商品！"];
    }else if ([_number intValue]>[_data[@"surplus"] intValue]){
        [FormValidator showAlertWithStr:@"购买商品数量超出了剩余商品数量！"];
//        _number=_data[@"surplus"];
//        self.hidesBottomBarWhenPushed=YES;
//        PayViewController *pay=[[PayViewController alloc]init];
//        pay.number=_number;
//        pay.value=_value;
//        pay.pid=_data[@"pid"];
//        pay.queue=_Qdata[@"queue"];
//        [self.navigationController pushViewController:pay animated:YES];
        
    }else{
        self.hidesBottomBarWhenPushed=YES;
        PayViewController *pay=[[PayViewController alloc]init];
        pay.number=_number;
        pay.value=_value;
        pay.pid=_data[@"pid"];
        pay.queue=_Qdata[@"queue"];
        pay.zg=_zg;
        [self.navigationController pushViewController:pay animated:YES];
        
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - 监听键盘方法
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.carView.y = self.view.height - self.carView.height;//这里的<span style="background-color: rgb(240, 240, 240);">self.toolbar就是我的输入框。</span>
            
        } else {
            self.carView.y = keyboardF.origin.y - self.carView.height;
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.carView.frame = CGRectMake(0, SCREEN_HEIGHT - 294, SCREEN_WIDTH, 40);
        
    }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMess];
    
    return YES;
}
- (void)sendMess
{
    
    if ([self.cartBtn.textField isFirstResponder]) {
        [self.cartBtn.textField resignFirstResponder];
    }
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
    
    _dataStr = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('pinfo')[0].value"];
    NSLog(@"____pinfo====%@",_dataStr);
  
    
    //转化为data
    NSData *jsonData = [_dataStr dataUsingEncoding:NSUTF8StringEncoding];
    //转化为字典
    _data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"22%@",_data[@"pid"]);
    if (_data!=nil) {
        [self addShoppingCartUI];
    }
    
      NSLog(@"______________zg___%@",_data[@"zg"]);
    _zg=_data[@"zg"];
    if ([_zg intValue]!=1) {
        _zg=@"0";
    }

    
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
     [_carView removeFromSuperview];
    if([@"bridge" isEqualToString:[url substringToIndex:6]]){
        NSArray *array = [url componentsSeparatedByString:@"data="];
        NSArray *array1 = [url componentsSeparatedByString:@"code="];
        NSString *code = [array1[1] substringToIndex:15];
        
        
        if([code containsString:@"wxpayApp"]){//需要跳转页面
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            NSString *newver = [userDefault objectForKey:@"newver"];
            
            if (IFNEWVER) {//跳转到充值页面
                BalanceViewController *pub=[[BalanceViewController alloc]init];
                // pub.pid=_pidStr;
                [self.navigationController pushViewController:pub animated:YES];
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
