//
//  ReusableView.h
//  Snatch
//
//  Created by Zhanggaoju on 16/9/28.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bannerData.h"
#import "silderMode.h"
#import "lotteryModel.h"
#import "ScrollImage.h"

#import "CCPScrollView.h"
#import "CCPActionSheetView.h"
#import "UIView+CCPExtension.h"

#import "WB_Stopwatch.h"
#import "AnnounceModel.h"
#import "AnnounceData.h"

#import "CLRollLabel.h"
#import "HDModel.h"

@interface HeaderView : UICollectionReusableView <ScrollImageDelegate,WB_StopWatchDelegate>
{
   int hight;
}
@property (nonatomic,strong) ScrollImage *scrol;

@property (nonatomic,strong) UIPageControl *pageControll;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) NSUInteger count;

@property (nonatomic,assign) CGFloat oldContentOffsetX;

@property (nonatomic,strong) UIView *announceView;

@property (nonatomic,strong) NSMutableArray *announceBtnArr;

@property (nonatomic,strong) UIScrollView *notificationSV;

@property (nonatomic,strong) NSArray *imageArr;

@property (nonatomic,strong) NSMutableArray *linkArr;

@property (nonatomic,strong) NSMutableArray *lotteryArr;

@property (nonatomic,strong) bannerData *bData;

@property (nonatomic,strong) UIViewController *nav;

@property (nonatomic,strong) NSMutableArray *announceDatas;

@property (strong, nonatomic) UIView *testView;
@property (nonatomic,strong) CCPScrollView *ccpView;

@property (nonatomic,strong) WB_Stopwatch * stopWatchLabel;
@property (nonatomic,strong) AnnounceModel *aModels;

@property (nonatomic,strong) UIImageView *pic;
@property (nonatomic,strong) NSMutableArray *aArr;
@property (nonatomic,strong) NSMutableArray *uUrlArr;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) NSMutableArray *timeLabelArr;

@property (nonatomic,strong) CLRollLabel *rollLabel;

@property (nonatomic,strong) NSMutableArray *hbArr;
@property (nonatomic,strong) NSString *open;

@property (nonatomic,strong) HDModel *hdModel;

@property (nonatomic,strong) NSString *hbStr;

 

@end
