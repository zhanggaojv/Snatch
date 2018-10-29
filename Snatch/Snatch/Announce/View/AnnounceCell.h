//
//  AnnounceCell.h
//  Snatch
//
//  Created by Zhanggaoju on 16/9/23.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WB_Stopwatch.h"
#import "AnnounceModel.h"
@interface AnnounceCell : UICollectionViewCell <WB_StopWatchDelegate>

@property (nonatomic,strong) UIImageView *picture;

@property (nonatomic,strong) UILabel *name;

@property (nonatomic,strong) UILabel *numberLabel;

@property (nonatomic,strong) UILabel *number;

@property (nonatomic,strong) UIImageView *announceImage;

@property (nonatomic,strong) UILabel *announceLabel;

@property (nonatomic,strong) UILabel *announceTime;

@property (nonatomic,strong) WB_Stopwatch * stopWatchLabel;

@property (nonatomic,strong) AnnounceModel *aModels;

@end
