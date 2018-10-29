//
//  SnatchCell.m
//  Snatch
//
//  Created by Zhanggaoju on 16/9/22.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "SnatchCell.h"
#import "SDetailsViewController.h"

#define PIC_BOUNDS CGSizeMake(self.bounds.size.width/3*2, self.bounds.size.width/3*2)

@implementation SnatchCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.picture = [[UIImageView alloc]init];
        self.picture.backgroundColor=[UIColor redColor];
        [self addSubview:self.picture];
        [self.picture mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(5);
            make.size.mas_equalTo(PIC_BOUNDS);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        self.name =[[UILabel alloc]init];
        self.name.numberOfLines = 2;
        [self addSubview:self.name];
        self.name.font=[UIFont systemFontOfSize:13];
        self.name.textColor=[UIColor darkTextColor];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bounds.size.width/4*3-5);
            make.left.mas_equalTo(self.mas_left).mas_offset(10);
            make.right.mas_equalTo(self.mas_right).mas_offset(-10);
            make.height.mas_equalTo(40);
            
        }];
        
        self.jdLabel =[[UILabel alloc]init];
        //self.jdLabel.text = @"进度:";
        self.jdLabel.font=[UIFont systemFontOfSize:13];
        self.jdLabel.textColor=LightBlackLabelTextColor;
        [self addSubview:self.jdLabel];
        [self.jdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.name.mas_bottom).mas_offset(-9);
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.left.mas_equalTo(10);
        }];
        
        self.jd =[[UILabel alloc]init];
        [self addSubview:self.jd];
        self.jd.font=[UIFont systemFontOfSize:13];
        self.jd.textColor=[UIColor darkBlue];
        [self.jd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.name.mas_bottom).mas_offset(-9);
            make.size.mas_equalTo(CGSizeMake(50, 30));
            make.left.mas_equalTo(self.jdLabel.mas_right).mas_offset(-10);
        }];
        
        self.jdProgress =[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.jdProgress.layer.masksToBounds = YES;
        self.jdProgress.layer.cornerRadius =3;
        [self addSubview:self.jdProgress];
        [self.jdProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.jd.mas_bottom).mas_offset(-2);
            make.size.mas_equalTo(CGSizeMake(self.width/5*3, 6));
            make.left.mas_equalTo(self.mas_left).mas_offset(5);
        }];
        self.jdProgress.trackTintColor = [UIColor groupTableViewBackgroundColor];
        _jdProgress.progress = [_sModels.jd floatValue]/(self.width/5*3);
        [_jdProgress setTintColor:[UIColor colorWithHexString:@"f2b63c"]];
        
        
        self.cyBtn = [[UIButton alloc]init];
        self.cyBtn.titleLabel.font=SYSTEM_FONT(11);
        self.cyBtn.backgroundColor=[UIColor whiteColor];
        self.cyBtn.layer.cornerRadius =5;
        self.cyBtn.layer.masksToBounds =YES;
        self.cyBtn.layer.borderWidth=1;
        self.cyBtn.layer.borderColor=kDefaultColor.CGColor;
        self.cyBtn.layer.rasterizationScale =kScreenScale;
        [self.cyBtn setTitle:@"马上参与" forState:UIControlStateNormal];
        [self.cyBtn setTitleColor:kDefaultColor forState:UIControlStateNormal];
        [self.cyBtn addTarget:self action:@selector(cyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        //[self.cyBtn setImage:[UIImage imageNamed:@"canyu"] forState:UIControlStateNormal];
        //[self.cyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.cyBtn];
        [self.cyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 25));
            make.left.mas_equalTo(_jdProgress.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(self.jdProgress.mas_centerY);
        }];
        
        self.label = [[UIImageView alloc]init];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake(30, 40));
            make.left.mas_equalTo(self.mas_left);
        }];
        self.label.hidden=YES;
        
    }
    
    return self;
}
//重写set方法赋值
-(void)setSModels:(SnatchModel *)sModels{
    _sModels = sModels;
    [self.picture sd_setImageWithURL:_sModels.imgUrl placeholderImage:[UIImage imageNamed:@"celldidan"]];
    self.name.text = _sModels.name;
    
    NSString *jdStr=[NSString stringWithFormat:@"进度:%@％",_sModels.jd];
    NSRange range = [jdStr rangeOfString:[NSString stringWithFormat:@"%@％",_sModels.jd]];
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:jdStr];
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"428bca"] range:range];
    self.jdLabel.attributedText = aStr;
    
    [self.jdProgress setProgress:[_sModels.jd floatValue]/100 animated:YES];
    
    
    if ([_sModels.ten intValue]==0) {
        _label.hidden=YES;
    }else if ([_sModels.ten intValue]==1){
        _label.hidden=NO;
        _label.image=[UIImage imageNamed:@"fzLabel"];
    }else if([_sModels.ten intValue]==5){
        _label.hidden=NO;
        _label.image=[UIImage imageNamed:@"shiyuanlabel"];
    }
}
-(void)cyBtnAction{
    self.nav.hidesBottomBarWhenPushed=YES;
    SDetailsViewController *datail=[[SDetailsViewController alloc]init];
    datail.detailurl=_sModels.url;
    [self.nav.navigationController pushViewController:datail animated:YES];
    self.nav.hidesBottomBarWhenPushed=NO;
    
    
}
@end
