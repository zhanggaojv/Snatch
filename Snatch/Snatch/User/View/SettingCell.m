//
//  SettingCell.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/10.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        self.menuLabel =[[UILabel alloc]init];
        [self.contentView addSubview:self.menuLabel];
        self.menuLabel.font=[UIFont systemFontOfSize:16];
        self.menuLabel.textColor=LightBlackLabelTextColor;
        [self.menuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_equalTo(10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
        self.Tline =[[UIView alloc]init];
        self.Tline.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:self.Tline];
        [self.Tline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, .5));
            make.top.mas_equalTo(self.contentView.mas_top);
        }];
        
        self.Bline =[[UIView alloc]init];
        self.Bline.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:self.Bline];
        [self.Bline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, .5));
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
