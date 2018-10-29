//
//  CJDViewController.h
//  Snatch
//
//  Created by Zhanggaoju on 2016/11/22.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJDViewController : UIViewController

@property (nonatomic,strong) UILabel *IDlabel;

@property (nonatomic,strong) UILabel *djLable;

@property (nonatomic,strong) UIProgressView *jd;

@property (nonatomic,strong) UILabel *zhanghu;
@property (nonatomic,strong) UILabel *ZHje;

@property (nonatomic,strong) UILabel *xianxia;
@property (nonatomic,strong) UILabel *XXje;

@property (nonatomic,strong) UILabel *renshu;
@property (nonatomic,strong) UILabel *rs;

@property (nonatomic,strong) UILabel *daili;
@property (nonatomic,strong) UILabel *dldj;

@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) NSString *token;

@property (strong,nonatomic) NSString *uid;

@property (strong,nonatomic) NSDictionary *data;

@property (strong,nonatomic) UIScrollView *scroll;

@end
