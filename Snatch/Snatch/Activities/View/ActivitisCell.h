//
//  ActivitisCell.h
//  Snatch
//
//  Created by Zhanggaoju on 16/9/23.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiviesModel.h"

@interface ActivitisCell : UITableViewCell

@property (nonatomic,strong) UIImageView *activitisImage;

@property (nonatomic,strong) UILabel *activitisLabel;

@property (nonatomic,strong) UIButton *activitisStatus;

@property (nonatomic,strong) UILabel *activitsiName;

@property (nonatomic,strong) ActiviesModel *aModels;



@end
