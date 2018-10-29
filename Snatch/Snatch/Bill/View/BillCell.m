//
//  BillCell.m
//  Snatch
//
//  Created by Zhanggaoju on 16/9/23.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "BillCell.h"
#import "BillUserViewController.h"
#import "ImageViewCell.h"
#import "SnatchRecordViewController.h"

#import "ImgCollectionViewController.h"
@interface BillCell ()
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) ImgCollectionViewController *imgView;

@end
static NSString *reuseIdentifiers = @"Cell";

@implementation BillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        
        self.billUseravatar = [[UIButton alloc]init];
        [self.contentView addSubview:self.billUseravatar];
        [self.billUseravatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
        }];
        self.billUseravatar.layer.masksToBounds =YES;
        self.billUseravatar.layer.cornerRadius = 20;
        self.billUseravatar.layer.borderWidth=3;
        self.billUseravatar.layer.borderColor=[UIColor whiteSmoke].CGColor;
        [self.billUseravatar addTarget:self action:@selector(tapUser) forControlEvents:UIControlEventTouchUpInside];
        
        self.billUserLabel =[[UILabel alloc]init];
        // self.billUserLabel.text=@"获奖者:";
        self.billUserLabel.font=[UIFont systemFontOfSize:13];
        self.billUserLabel.textColor=LightBlackLabelTextColor;
        [self.contentView addSubview:self.billUserLabel];
        [self.billUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(15);
            make.left.mas_equalTo(self.billUseravatar.mas_right).mas_offset(5);
            make.size.mas_equalTo(CGSizeMake(260, 30));
        }];
        
        self.billUser =[[UILabel alloc]init];
        self.billUser.font=[UIFont systemFontOfSize:13];
        self.billUser.textColor=[UIColor blueColor];
        [self.contentView addSubview:self.billUser];
        [self.billUser mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(15);
            make.left.mas_equalTo(self.billUserLabel.mas_right);
            make.size.mas_equalTo(CGSizeMake(200, 30));
        }];
        
        
        
        self.billNumberLabel =[[UILabel alloc]init];
        //self.billNumberLabel.text=@"幸运号码:";
        self.billNumberLabel.font=[UIFont systemFontOfSize:13];
        self.billNumberLabel.textColor=LightBlackLabelTextColor;
        [self.contentView addSubview:self.billNumberLabel];
        [self.billNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.billUserLabel.mas_bottom).mas_offset(2);
            make.left.mas_equalTo(self.billUseravatar.mas_right).mas_offset(5);
            make.size.mas_equalTo(CGSizeMake(280, 30));
        }];
        
        self.billNumber =[[UILabel alloc]init];
        self.billNumber.textColor =[UIColor redColor];
        self.billNumber.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.billNumber];
        [self.billNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.billUserLabel.mas_bottom).mas_offset(2);
            make.left.mas_equalTo(self.billNumberLabel.mas_right);
            make.size.mas_equalTo(CGSizeMake(200, 30));
        }];
        
        self.participantsLabel =[[UILabel alloc]init];
        //self.participantsLabel.text=@"本期参与:";
        self.participantsLabel.font=[UIFont systemFontOfSize:13];
        self.participantsLabel.textColor=LightBlackLabelTextColor;
        [self.contentView addSubview:self.participantsLabel];
        [self.participantsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.billNumberLabel.mas_bottom).mas_offset(2);
            make.left.mas_equalTo(self.billUseravatar.mas_right).mas_offset(5);
            make.size.mas_equalTo(CGSizeMake(180, 30));
        }];
        
        self.participants =[[UILabel alloc]init];
        self.participants.textColor =[UIColor purpleColor];
        self.participants.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.participants];
        //        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"520人次"];
        //        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,3)];
        //        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,2)];
        //        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:18.0] range:NSMakeRange(0, 3)];
        //        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:20.0] range:NSMakeRange(3, 2)];
        //        self.participants.attributedText = str;
        
        [self.participants mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.billNumberLabel.mas_bottom).mas_offset(2);
            make.left.mas_equalTo(self.participantsLabel.mas_right);
            make.size.mas_equalTo(CGSizeMake(200, 30));
        }];
        
        self.billText =[[UILabel alloc]init];
        self.billText.numberOfLines = 3;
        self.billText.font=[UIFont systemFontOfSize:13];
        self.billText.textColor=[UIColor blackColor];
        [self.contentView addSubview:self.billText];
        [self.billText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.participantsLabel.mas_bottom).mas_offset(2);
            make.left.mas_equalTo(self.mas_left).mas_offset(40);
            make.size.mas_equalTo(CGSizeMake(self.width-80, 60));
        }];
        
        if (self.imgView.isViewLoaded) return nil;
        self.imgView = [[ImgCollectionViewController alloc]init];
        //self.imgView.view.frame = CGRectMake(40, 165, WSSCREENWIDTH - 80, 80);
        self.imgView.view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.imgView.view];
        
        [self.imgView.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.billText.mas_bottom).offset(1);
            make.left.equalTo(self.contentView.mas_left).offset(40);
            make.right.equalTo(self.contentView.mas_right).offset(-40);
            make.height.mas_equalTo(80);
        }];
        
        _shared_time=[[UILabel alloc]init];
        _shared_time.font=[UIFont systemFontOfSize:12];
        _shared_time.textAlignment=NSTextAlignmentRight;
        _shared_time.textColor=[UIColor lightSeaGreen];
        [self.contentView addSubview:_shared_time];
        [_shared_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-5);
            make.right.mas_equalTo(self.mas_right).mas_offset(-10);
            make.size.mas_equalTo(CGSizeMake(200, 18));
        }];
        
        
        self.line =[[UIView alloc]init];
        self.line.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            
        }];
        
        
    }
    
    return self;
}

-(void)setBModel:(BillModel *)bModel{
    
    _bModel= bModel;
    [self.billUseravatar sd_setImageWithURL:_bModel.imgUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"celldidan"]];
    
    NSString *jdStr1=[NSString stringWithFormat:@"获奖者:%@(%@)",_bModel.name,_bModel.address];
    NSRange range1 = [jdStr1 rangeOfString:[NSString stringWithFormat:@"%@",_bModel.name]];
    NSRange range11 = [jdStr1 rangeOfString:[NSString stringWithFormat:@"%@",_bModel.address]];
    NSMutableAttributedString *aStr1 = [[NSMutableAttributedString alloc] initWithString:jdStr1];
    [aStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"428bca"] range:range1];
    [aStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor fireBrick] range:range11];
    self.billUserLabel.attributedText = aStr1;
    //self.billUser.text = [NSString stringWithFormat:@"%@（%@）",_bModel.name,_bModel.address];
    
    NSString *jdStr2=[NSString stringWithFormat:@"幸运号码:%@",_bModel.kaijang_num];
    NSRange range2 = [jdStr2 rangeOfString:[NSString stringWithFormat:@"%@",_bModel.kaijang_num]];
    NSMutableAttributedString *aStr2 = [[NSMutableAttributedString alloc] initWithString:jdStr2];
    [aStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor forestGreen] range:range2];
    [aStr2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:15.0] range:range2];
    self.billNumberLabel.attributedText = aStr2;
    
    //self.billNumber.text=_bModel.kaijang_num;
    
    NSString *jdStr3=[NSString stringWithFormat:@"本期参与:%@人次",_bModel.count];
    NSRange range3 = [jdStr3 rangeOfString:[NSString stringWithFormat:@"%@",_bModel.count]];
    NSRange range33 = [jdStr3 rangeOfString:[NSString stringWithFormat:@"人次"]];
    NSMutableAttributedString *aStr3 = [[NSMutableAttributedString alloc] initWithString:jdStr3];
    [aStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor peachRed] range:range3];
    [aStr3 addAttribute:NSForegroundColorAttributeName value:LightBlackLabelTextColor range:range33];
    [aStr3 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14.0] range:range3];
    self.participantsLabel.attributedText = aStr3;
    //self.participants.text=[NSString stringWithFormat:@"%@人次",_bModel.count];
    
    self.billText.text=_bModel.content;
    
    self.imgView.bModels = _bModel;
    
    _shared_time.text=_bModel.shared_time;
    
    
}

-(void)tapUser{
    self.nav.hidesBottomBarWhenPushed=YES;
    SnatchRecordViewController *userVC=[[SnatchRecordViewController alloc]init];
    userVC.Url=_bModel.user_url;
    [self.nav.navigationController pushViewController:userVC animated:YES];
    self.nav.hidesBottomBarWhenPushed=NO;
    
}
- (void)setFrame:(CGRect)frame {
    
    frame.size.width =SCREEN_WIDTH-10;
    frame.origin.x +=(SCREEN_WIDTH-frame.size.width)/2;
    
    
    [super setFrame:frame];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
