//
//  AnnounceCell.m
//  Snatch
//
//  Created by Zhanggaoju on 16/9/23.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "AnnounceCell.h"


#define PIC_BOUNDS CGSizeMake(self.bounds.size.width/3*2, self.bounds.size.width/3*2)

@implementation AnnounceCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.picture = [[UIImageView alloc]init];
        self.picture.backgroundColor=[UIColor whiteSmoke];;
        [self addSubview:self.picture];
        
        [self.picture mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(5);
            make.size.mas_equalTo(PIC_BOUNDS);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        self.name =[[UILabel alloc]init];
        [self addSubview:self.name];
        self.name.textColor=[UIColor darkTextColor];;
        self.name.font=[UIFont systemFontOfSize:13];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bounds.size.width/4*3);
            make.left.mas_equalTo(self.mas_left).mas_offset(10);
            make.right.mas_equalTo(self.mas_right).mas_offset(-10);
            make.height.mas_equalTo(20);
            
        }];
        
        self.numberLabel =[[UILabel alloc]init];
        //self.numberLabel.text = @"期号:";
        self.numberLabel.textColor=LightBlackLabelTextColor;
        self.numberLabel.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.name.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(120, 20));
            make.left.mas_equalTo(10);
        }];
        
        self.number =[[UILabel alloc]init];
        self.number.textColor=[UIColor darkBlue];
        self.number.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.number];
        [self.number mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.name.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(90, 20));
            make.left.mas_equalTo(self.numberLabel.mas_right);
        }];
        
        self.announceImage = [[UIImageView alloc]init];
        self.announceImage.image =[UIImage imageNamed:@"announce"];
        [self addSubview:self.announceImage];
        [self.announceImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.numberLabel.mas_bottom).mas_offset(2);
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.left.mas_equalTo(self.mas_left).mas_offset(5);
        }];
        self.announceImage.layer.masksToBounds = YES;
        self.announceImage.layer.cornerRadius = 8;
        
        self.announceLabel = [[UILabel alloc]init];
        [self addSubview:self.announceLabel];
        self.announceLabel.font=[UIFont systemFontOfSize:13];
        self.announceLabel.text=@"即将揭晓:";
        self.announceLabel.textColor=kDefaultColor;
        [self.announceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.announceImage.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(90, 20));
            make.left.mas_equalTo(self.announceImage.mas_right).mas_offset(5);
        }];
        
        self.announceTime = [[UILabel alloc]init];
        self.announceTime.textColor=kDefaultColor;
        self.announceTime.font=[UIFont systemFontOfSize:25 ];
        [self addSubview:self.announceTime];
        [self.announceTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.announceLabel.mas_bottom).mas_offset(-3);
            make.size.mas_equalTo(CGSizeMake(140, 50));
            make.left.mas_equalTo(self.mas_left).mas_offset(20);
        }];
        if (!self.stopWatchLabel) {
            self.stopWatchLabel = [[WB_Stopwatch alloc]initWithLabel:self.announceTime andTimerType:WBTypeTimer];
            }
        self.stopWatchLabel.delegate = self;
        [self.stopWatchLabel setTimeFormat:@"mm:ss:SS"];
        
    }
    return self;
    
}

//重写set方法赋值

-(void)setAModels:(AnnounceModel *)aModels{
    _aModels = aModels;
    [self.picture sd_setImageWithURL:_aModels.imgUrl placeholderImage:[UIImage imageNamed:@"celldidan"]];
    self.name.text = _aModels.name;
    
    NSString *jdStr=[NSString stringWithFormat:@"期号:%@",_aModels.no];
    NSRange range = [jdStr rangeOfString:[NSString stringWithFormat:@"%@",_aModels.no]];
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:jdStr];
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"428bca"] range:range];
    self.numberLabel.attributedText = aStr;
    //self.number.text = _aModels.no;
    [self.stopWatchLabel setCountDownTime:[_aModels.kaijang_diffe floatValue]/1000];//多少秒
    [self.stopWatchLabel start];
   
    
}
//时间到了
-(void)timerLabel:(WB_Stopwatch*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
     //NSLog(@"时间到了");
     [[NSNotificationCenter defaultCenter]postNotificationName:@"timeStop" object:nil userInfo:nil];
    [self.stopWatchLabel pause];
    
}

//开始倒计时
-(void)timerLabel:(WB_Stopwatch*)timerlabel
       countingTo:(NSTimeInterval)time
        timertype:(WB_StopwatchLabelType)timerType {
   // NSLog(@"time:%f",time);
    
}

@end
