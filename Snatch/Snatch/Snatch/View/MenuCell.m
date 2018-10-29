//
//  MenuCell.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/11/16.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

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
            make.size.mas_equalTo(CGSizeMake(20,20));
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
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
