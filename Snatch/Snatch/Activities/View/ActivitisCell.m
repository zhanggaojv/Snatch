//
//  ActivitisCell.m
//  Snatch
//
//  Created by Zhanggaoju on 16/9/23.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "ActivitisCell.h"

@implementation ActivitisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        self.activitisImage =[[UIImageView alloc]init];
        [self.contentView addSubview:self.activitisImage];
        [self.activitisImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        self.activitisImage.layer.masksToBounds = YES;
        self.activitisImage.layer.cornerRadius = 25;
        self.activitisImage.layer.borderWidth=3;
        self.activitisImage.layer.borderColor=[UIColor whiteSmoke].CGColor;
        
        self.activitisLabel =[[UILabel alloc]init];
        self.activitisLabel.textColor=[UIColor colorWithHexString:@"428bca"];
        //self.activitisLabel.text = @"邀请有礼";
        self.activitisLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.activitisLabel];
        [self.activitisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.activitisImage.mas_top);
            make.size.mas_equalTo(CGSizeMake(150, 30));
            make.left.mas_equalTo(self.activitisImage.mas_right).mas_offset(8);
        }];

        self.activitisStatus =[[UIButton alloc]init];
        self.activitisStatus.titleLabel.font=SYSTEM_FONT(13);
        self.activitisStatus.layer.cornerRadius =4;
        self.activitisStatus.layer.masksToBounds =YES;
        self.activitisStatus.layer.rasterizationScale =kScreenScale;
        
       
        self.activitisStatus.titleLabel.textColor=[UIColor whiteColor];
        [self.contentView addSubview:self.activitisStatus];
        [self.activitisStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.activitisLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(45, 20));
            make.left.mas_equalTo(self.activitisLabel.mas_right);
        }];
        
        self.activitsiName =[[UILabel alloc]init];
        self.activitsiName.numberOfLines = 2;
        self.activitsiName.font=[UIFont systemFontOfSize:12];
        self.activitsiName.textColor=[UIColor darkTextColor];
        [self.contentView addSubview:self.activitsiName];
        [self.activitsiName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(8);
            make.size.mas_equalTo(CGSizeMake(self.width/3*2, 60));
            make.left.mas_equalTo(self.activitisImage.mas_right).mas_offset(8);
        }];
        
    }
    return self;
}

-(void)setAModels:(ActiviesModel *)aModels{
    _aModels = aModels;
    
    [self.activitisImage sd_setImageWithURL:_aModels.imgUrl placeholderImage:[UIImage imageNamed:@"touxiang"]];
    self.activitisLabel.text=_aModels.title;
    self.activitsiName.text =_aModels.remark;
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    NSLog(@"获取当前时间戳:%d",[timeString intValue]);
    if ([_aModels.end_time intValue]>[timeString intValue]) {
         [self.activitisStatus setTitle:@"在进行" forState:UIControlStateNormal];
        self.activitisStatus.backgroundColor=[UIColor colorWithHexString:@"5CB85C"];
    }else{
        [self.activitisStatus setTitle:@"已结束" forState:UIControlStateNormal];
        self.activitisStatus.backgroundColor=[UIColor colorWithHexString:@"D9534F"];
        
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
