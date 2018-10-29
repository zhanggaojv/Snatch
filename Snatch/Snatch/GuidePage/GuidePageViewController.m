//
//  GuidePageViewController.m
//  夺你所爱
//
//  Created by Zhanggaoju on 16/9/20.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "GuidePageViewController.h"
#import "AppDelegate.h"

@interface GuidePageViewController ()

@property (nonatomic,strong) UIScrollView *GuideSv;
@property (nonatomic,strong) NSMutableArray *arr;

@end

@implementation GuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.GuideSv.backgroundColor=[UIColor blackColor];
    
//    NSDictionary *dic=@{@"code":@"xpics"};
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//    //加密
//    NSString *encryptDate=[SecurityUtil dataAESdata:data];
//    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
//    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result) {
//        
//        NSDictionary *data = result[@"data"];
//        _arr=[NSMutableArray array];
//        for (NSString *value in data.allValues) {
//            [_arr addObject:value];
//        }
//        
//         [self scrollView];
//        
//    } failure:^(NSError *erro) {
//        NSLog(@"请求错误");
//        
//    } showHUD:self.view];
      [self scrollView];
}
-(UIScrollView *)scrollView{
    if (!_GuideSv) {
        _GuideSv = [[UIScrollView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:self.GuideSv];

        for (int i=0; i<3; i++) {
            UIImageView *imageV =[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            NSURL *picUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@",_arr[i]]];
            //[imageV sd_setImageWithURL:picUrl placeholderImage:nil];
            imageV.image=[UIImage imageNamed:[NSString stringWithFormat:@"%dp.png",i]];
            if (i == 2) {
                //打开图片事件交互
                imageV.userInteractionEnabled = YES;
                
                [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMainViewController:)]];
            }
            
            
            [_GuideSv addSubview:imageV];
        }
        
        _GuideSv.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT);
        _GuideSv.contentOffset = CGPointMake(0, 0);
        
        _GuideSv.pagingEnabled = YES;
        
        _GuideSv.showsHorizontalScrollIndicator = NO;
        
    }

    return _GuideSv;
}

//当点击了最后一张引导页时，应该显示主界面
- (void)showMainViewController:(UITapGestureRecognizer *)tap{
    NSLog(@"点击了最后一张引导页");
    //获取appdelegate类的对象，它的对象是一个单例类的对象
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    //切换跟视图
    [app setWindowRootViewController];
    
    //设置一个引导页已经运行过的标志 并把这个标志保存到本地
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"GUIDE_STATUS"];
    
    //为了防止这种本地数据持久化的方式没有及时的将数据保存
    //添加如下代码，一般不写也不错，最好写上
    [[NSUserDefaults standardUserDefaults] synchronize];
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
