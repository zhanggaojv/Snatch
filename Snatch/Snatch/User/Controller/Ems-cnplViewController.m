//
//  Ems-cnplViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/11/15.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "Ems-cnplViewController.h"

@interface Ems_cnplViewController ()

@end

@implementation Ems_cnplViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBarButtonItem];
    self.view.backgroundColor=[UIColor whiteColor];
    YYLabel *titile=[[YYLabel alloc]init];
    titile.text=@"扫描二维码，关注公众号。";
    titile.font=[UIFont systemFontOfSize:18];
    [titile setTextAlignment:NSTextAlignmentCenter];
    titile.textColor=[UIColor rosyBrown];
    [titile setLayerShadow:[UIColor fireBrick] offset:CGSizeMake(3.1/2.0, -0.1/2.0) radius:12/2.0];
    [self.view addSubview:titile];
    
    [titile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
    }];
    
    
    UIImageView *ems_cnpImage=[[UIImageView alloc]init];
    ems_cnpImage.image=[UIImage imageNamed:@"emsImage"];
    [self.view addSubview:ems_cnpImage];
    [ems_cnpImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3));
    }];
}
-(void)addBarButtonItem{
    UIImage* Limage= [UIImage imageNamed:@"liftBtn"];
    CGRect Lframe= CGRectMake(0, 0, 20, 20);
    UIButton *LsomeButton= [[UIButton alloc] initWithFrame:Lframe];
    [LsomeButton addTarget:self action:@selector(Lback) forControlEvents:UIControlEventTouchUpInside];
    [LsomeButton setBackgroundImage:Limage forState:UIControlStateNormal];
    [LsomeButton setShowsTouchWhenHighlighted:YES];
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:LsomeButton];
    
    UIImage* Rimage= [UIImage imageNamed:@"erweima"];
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
