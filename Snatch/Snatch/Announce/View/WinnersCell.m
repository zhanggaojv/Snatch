//
//  WinnersCell.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/13.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "WinnersCell.h"

#define PIC_BOUNDS CGSizeMake(self.bounds.size.width/3*2, self.bounds.size.width/3*2)

@implementation WinnersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.prizePicture = [[UIImageView alloc]init];
        self.prizePicture.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.prizePicture];
        [self.prizePicture mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(5);
            make.size.mas_equalTo(PIC_BOUNDS);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        self.prizeName =[[UILabel alloc]init];
        [self addSubview:self.prizeName];
        self.prizeName.textColor=[UIColor darkTextColor];;
        self.prizeName.font=[UIFont systemFontOfSize:13];
        [self.prizeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bounds.size.width/4*3);
            make.left.mas_equalTo(self.mas_left).mas_offset(10);
            make.right.mas_equalTo(self.mas_right).mas_offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        self.winnerLabel =[[UILabel alloc]init];
        //self.winnerLabel.text = @"获奖者:";
        self.winnerLabel.textColor=LightBlackLabelTextColor;
        self.winnerLabel.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.winnerLabel];
        [self.winnerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.prizeName.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(150, 20));
            make.left.mas_equalTo(10);
        }];
        
        self.winner =[[UILabel alloc]init];
        self.winner.textColor=[UIColor darkBlue];
        self.winner.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.winner];
        [self.winner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.prizeName.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(100, 20));
            make.left.mas_equalTo(self.winnerLabel.mas_right);
        }];
        
        self.pNimberLabel =[[UILabel alloc]init];
        //self.pNimberLabel.text = @"参与人次:";
        self.pNimberLabel.textColor=LightBlackLabelTextColor;
        self.pNimberLabel.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.pNimberLabel];
        [self.pNimberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.winnerLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(160, 20));
            make.left.mas_equalTo(10);
        }];
        
        self.pNimber =[[UILabel alloc]init];
        self.pNimber.textColor=[UIColor forestGreen];
        self.pNimber.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.pNimber];
        [self.pNimber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.winnerLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(90, 20));
            make.left.mas_equalTo(self.pNimberLabel.mas_right);
        }];
        
        self.winNumberLabel =[[UILabel alloc]init];
        //self.winNumberLabel.text = @"幸运号码:";
        self.winNumberLabel.textColor=LightBlackLabelTextColor;
        self.winNumberLabel.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.winNumberLabel];
        [self.winNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.pNimberLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(160, 20));
            make.left.mas_equalTo(10);
        }];
        
        self.winNumber =[[UILabel alloc]init];
        self.winNumber.textColor=[UIColor purpleColor];
        self.winNumber.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.winNumber];
        [self.winNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.pNimberLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(90, 20));
            make.left.mas_equalTo(self.winNumberLabel.mas_right);
        }];
        
        self.winTimeLabel =[[UILabel alloc]init];
        //self.winTimeLabel.text = @"揭晓时间:";
        self.winTimeLabel.textColor=LightBlackLabelTextColor;
        self.winTimeLabel.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.winTimeLabel];
        [self.winTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.winNumberLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(160, 20));
            make.left.mas_equalTo(10);
        }];
        
        self.winTime =[[UILabel alloc]init];
        self.winTime.textColor=kDefaultColor;
        self.winTime.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.winTime];
        [self.winTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.winNumberLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(90, 20));
            make.left.mas_equalTo(self.winTimeLabel.mas_right);
        }];
        
    }
    return self;
}

-(void)setWModels:(AnnounceModel *)wModels{
    _wModels=wModels;
    [self.prizePicture sd_setImageWithURL:_wModels.imgUrl placeholderImage:[UIImage imageNamed:@"celldidan"]];
    
    self.prizeName.text=_wModels.name;
    
    NSString *jdStr1=[NSString stringWithFormat:@"获奖者:%@",_wModels.user];
    NSRange range1 = [jdStr1 rangeOfString:[NSString stringWithFormat:@"%@",_wModels.user]];
    NSMutableAttributedString *aStr1 = [[NSMutableAttributedString alloc] initWithString:jdStr1];
    [aStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"428bca"] range:range1];
    self.winnerLabel.attributedText = aStr1;
    //self.winner.text=_wModels.user;
    
    NSString *jdStr2=[NSString stringWithFormat:@"参与人次:%@",_wModels.count];
    NSRange range2 = [jdStr2 rangeOfString:[NSString stringWithFormat:@"%@",_wModels.count]];
    NSMutableAttributedString *aStr2 = [[NSMutableAttributedString alloc] initWithString:jdStr2];
    [aStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor forestGreen] range:range2];
    self.pNimberLabel.attributedText = aStr2;
    //self.pNimber.text=_wModels.count;
    
    NSString *jdStr3=[NSString stringWithFormat:@"幸运号码:%@",_wModels.kaijang_num];
    NSRange range3 = [jdStr3 rangeOfString:[NSString stringWithFormat:@"%@",_wModels.kaijang_num]];
    NSMutableAttributedString *aStr3 = [[NSMutableAttributedString alloc] initWithString:jdStr3];
    [aStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor peachRed] range:range3];
    self.winNumberLabel.attributedText = aStr3;
    //self.winNumber.text=_wModels.kaijang_num;

    NSString *jdStr4=[NSString stringWithFormat:@"揭晓时间:%@",_wModels.kaijang_time];
    NSRange range4 = [jdStr4 rangeOfString:[NSString stringWithFormat:@"%@",_wModels.kaijang_time]];
    NSMutableAttributedString *aStr4 = [[NSMutableAttributedString alloc] initWithString:jdStr4];
    [aStr4 addAttribute:NSForegroundColorAttributeName value:kDefaultColor range:range4];
    self.winTimeLabel.attributedText = aStr4;
    //self.winTime.text=_wModels.kaijang_time;
    
    
}
@end
