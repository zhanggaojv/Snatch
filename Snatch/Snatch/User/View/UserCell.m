//
//  UserCell.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/6.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        self.menuImgView =[[UIImageView alloc]init];
        [self.contentView addSubview:self.menuImgView];
        [self.menuImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        self.menuLabel =[[UILabel alloc]init];
        [self.contentView addSubview:self.menuLabel];
        self.menuLabel.font=[UIFont systemFontOfSize:14];
        self.menuLabel.textColor=LightBlackLabelTextColor;
        [self.menuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.menuImgView.mas_right).mas_equalTo(6);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
        self.Tline =[[UIView alloc]init];
        self.Tline.backgroundColor=[UIColor groupTableViewBackgroundColor];
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
