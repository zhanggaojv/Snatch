//
//  MeansCell.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/12/17.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "MeansCell.h"

@implementation MeansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
    }
    
    _titile=[UILabel new];
    [self.contentView addSubview:self.titile];
    self.titile.font=[UIFont systemFontOfSize:16];
    self.titile.textColor=LightBlackLabelTextColor;
    [self.titile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_equalTo(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    return self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
