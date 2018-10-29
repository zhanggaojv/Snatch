//
//  BillCell.h
//  Snatch
//
//  Created by Zhanggaoju on 16/9/23.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillModel.h"

@interface BillCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIButton *billUseravatar;

@property (nonatomic,strong) UILabel *billUserLabel;

@property (nonatomic,strong) UILabel *billUser;

@property (nonatomic,strong) UILabel *billNumberLabel;

@property (nonatomic,strong) UILabel *billNumber;

@property (nonatomic,strong) UILabel *participantsLabel;

@property (nonatomic,strong) UILabel *participants;

@property (nonatomic,strong) UILabel *billText;

@property (nonatomic,strong) UIImageView *billImages;

@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) BillModel *bModel;

@property (nonatomic,strong) UILabel *shared_time;

@property (nonatomic,strong) UIViewController *nav;



@end
