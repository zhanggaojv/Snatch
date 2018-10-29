//
//  WinnersCell.h
//  Snatch
//
//  Created by Zhanggaoju on 16/10/13.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnounceModel.h"

@interface WinnersCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *prizePicture;

@property (nonatomic,strong) UILabel *prizeName;

@property (nonatomic,strong) UILabel *prizeNumber;

@property (nonatomic,strong) UILabel *winnerLabel;

@property (nonatomic,strong) UILabel *winner;

@property (nonatomic,strong) UILabel *pNimberLabel;

@property (nonatomic,strong) UILabel *pNimber;

@property (nonatomic,strong) UILabel *winNumberLabel;

@property (nonatomic,strong) UILabel *winNumber;

@property (nonatomic,strong) UILabel *winTimeLabel;

@property (nonatomic,strong) UILabel *winTime;

@property (nonatomic,strong) AnnounceModel *wModels;


@end
