//
//  redCell.h
//  Snatch
//
//  Created by Zhanggaoju on 2016/12/16.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "redModel.h"

@interface redCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imageH;

@property (nonatomic,strong) UIImageView *ImageC;

@property (nonatomic,strong) UILabel *money;

@property (nonatomic,strong) UILabel *money_type;

@property (nonatomic,strong) UILabel *title;

@property (nonatomic,strong) UILabel *fw;

@property (nonatomic,strong) UILabel *endtime;

@property (nonatomic,strong) redModel *aModels;

@end
