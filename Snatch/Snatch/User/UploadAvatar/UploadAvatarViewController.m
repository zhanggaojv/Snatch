//
//  UploadAvatarViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/10/25.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "UploadAvatarViewController.h"
#import "UIViewController+XHPhoto.h"

@interface UploadAvatarViewController ()

@end

@implementation UploadAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self addBarButtonItem];
    [self addUI];
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

-(void)addUI{
    UILabel *lab=[[UILabel alloc]init];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.text=@"选择头像";
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view.mas_top).mas_offset(80);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.left.mas_offset((SCREEN_WIDTH-100)/2);
    }];
    UIButton *btn=[[UIButton alloc]init];
    [btn setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selectorPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab.mas_bottom).mas_offset(30);
        make.size.mas_equalTo(CGSizeMake(119, 119));
        make.left.mas_offset((SCREEN_WIDTH-119)/2);
    }];
    
    UIButton *cbtn=[[UIButton alloc]init];
    cbtn.layer.masksToBounds=YES;
    cbtn.layer.cornerRadius=2;
    cbtn.backgroundColor=[UIColor redColor];
    [cbtn setTitle:@"保存头像" forState:UIControlStateNormal];
    cbtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    cbtn.titleLabel.font=[UIFont systemFontOfSize:16 weight:2];
    [cbtn addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cbtn];
    [cbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).mas_offset(60);
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.left.mas_offset((SCREEN_WIDTH-80)/2);
    }];
    
}
-(void)selectorPhoto:(UIButton *)btn{
    /*
     edit:照片需要裁剪:传YES,不需要裁剪传NO(默认NO)
     */
    [self showCanEdit:YES photo:^(UIImage *photo) {
        
        [btn setBackgroundImage:photo forState:UIControlStateNormal];
        _avatar = photo;
    }];
}
-(void)savePhoto{
    NSMutableArray *avatarArr=[NSMutableArray array];
    [avatarArr addObject:_avatar];
    //图片转成data
    NSData *picData = UIImageJPEGRepresentation(_avatar, 0.5);
    
    NSMutableDictionary *Exparams = [[NSMutableDictionary alloc]init];
    //放到数组里边
    [Exparams addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:picData,@"file", nil]];
    
    self.token=[GJTokenManager accessToken];
    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    NSDictionary *dic=@{@"ht":@"1"};
    [CKHttpCommunicate createRequest:HTTP_Image withToken:token WithParam:dic withExParam:Exparams withMethod:POST success:^(id result) {
        NSLog(@"%@",result);
        NSLog(@"%@",result[@"msg"]);
        
    } uploadFileProgress:^(NSProgress *uploadProgress) {
        NSLog(@"uploadProgress:%@",uploadProgress);
    } failure:^(NSError *erro) {
        NSLog(@"上传失败……");
    }];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationTX" object:nil];
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
