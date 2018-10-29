//
//  SnatchCell.h
//  Snatch
//
//  Created by Zhanggaoju on 16/9/22.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnatchModel.h"
@interface SnatchCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *picture;

@property (nonatomic,strong) UILabel *name;

@property (nonatomic,strong) UILabel *jdLabel;

@property (nonatomic,strong) UILabel *jd;

@property (nonatomic,strong) UIProgressView *jdProgress;

@property (nonatomic,strong) UIButton *cyBtn;

@property (nonatomic,strong) SnatchModel *sModels;

@property (nonatomic,strong) UIImageView *label;

@property (nonatomic,strong) UIViewController *nav;

@end
