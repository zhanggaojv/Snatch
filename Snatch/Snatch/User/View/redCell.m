//
//  redCell.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/12/16.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "redCell.h"

@implementation redCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor=[UIColor groupTableViewBackgroundColor];
        _imageH=[UIImageView new];
        _imageH.image=[UIImage imageNamed:@"hongbao_red"];
        [self addSubview:_imageH];
        [_imageH mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(100, 120));
            make.top.mas_equalTo(15);
        }];
        
        _ImageC=[UIImageView new];
        _ImageC.image=[UIImage imageNamed:@"hongbaow"];
        [self addSubview:_ImageC];
        [_ImageC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageH.mas_left);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(_imageH.mas_top);
        }];
        
        _money=[UILabel new];
        _money.textColor=[UIColor whiteColor];
        _money.font=[UIFont systemFontOfSize:19 weight:5];
        _money.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_money];
        [_money mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.centerX.mas_equalTo(_imageH.mas_centerX);
            make.centerY.mas_equalTo(_imageH.mas_centerY);
        }];
        
        _money_type=[UILabel new];
        _money_type.textColor=[UIColor whiteColor];
        _money_type.font=[UIFont systemFontOfSize:16];
        _money_type.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_money_type];
        [_money_type mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.centerX.mas_equalTo(_imageH.mas_centerX);
            make.top.mas_equalTo(_money.mas_bottom);
        }];
        
        _title=[UILabel new];
        _title.textColor=[UIColor blackColor];
        _title.font=[UIFont systemFontOfSize:16];
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-120, 30));
            make.left.mas_equalTo(_imageH.mas_right).mas_offset(10);
            make.top.mas_equalTo(_imageH.mas_top).mas_offset(10);
        }];
        
        _fw=[UILabel new];
        _fw.textColor=[UIColor blackColor];
        _fw.font=[UIFont systemFontOfSize:15];
        [self addSubview:_fw];
        [_fw mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-120, 30));
            make.left.mas_equalTo(_imageH.mas_right).mas_offset(10);
            make.top.mas_equalTo(_title.mas_bottom);
        }];
        
        _endtime=[UILabel new];
        _endtime.textColor=[UIColor blackColor];
        _endtime.font=[UIFont systemFontOfSize:15];
        [self addSubview:_endtime];
        [_endtime mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-120, 30));
            make.left.mas_equalTo(_imageH.mas_right).mas_offset(10);
            make.top.mas_equalTo(_fw.mas_bottom);
        }];

    }
    return self;
}
-(void)setAModels:(redModel *)aModels{
    
    _aModels=aModels;
    
    _money.text=_aModels.money;
    
    if ([_aModels.money_type intValue]==1) {
        _money_type.text=@"夺宝币";
    }else if ([_aModels.money_type intValue]==2) {
        _money_type.text=@"佣金";
    }else if ([_aModels.money_type intValue]==3) {
        _money_type.text=@"积分换";
    }else if([_aModels.money_type intValue]==4) {
        _money_type.text=@"充值卡";
    }
    
    if ([_aModels.money_type intValue]<5) {
        _title.text=@"直减红包";
        _fw.text=@"使用范围:所有商品";
    }else if ([_aModels.money_type intValue]==5) {
        _title.text=@"满减红包";
        _fw.text=@"使用范围:满额商品";
    }
    
    _endtime.text=[NSString stringWithFormat:@"有效时间:%@",_aModels.endtime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
