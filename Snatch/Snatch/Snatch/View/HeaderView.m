//
//  ReusableView.m
//  Snatch
//
//  Created by Zhanggaoju on 16/9/28.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//
//#define hight 30

#import "HeaderView.h"
#import "BannerViewController.h"
#import "ActionBarViewController.h"
#import "ADetailsViewController.h"
#import "AnnounceViewController.h"


@implementation HeaderView


-(UICollectionReusableView *)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
            hight=0;

    }
    return self;
}

-(void)addGuideScollViewUI{

    _rollLabel = [[CLRollLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30) font:[UIFont systemFontOfSize:15] textColor:[UIColor redColor]];
    _rollLabel.backgroundColor = [UIColor goldColor];
//    _rollLabel.text = _hbStr;
    _rollLabel.layer.borderWidth=2;
    _rollLabel.layer.borderColor=[UIColor goldColor].CGColor;
    _rollLabel.layer.masksToBounds=YES;
    [self addSubview:_rollLabel];
    
    _scrol=[[ScrollImage alloc]initWithCurrentController:self.nav urlString:_imageArr viewFrame:CGRectMake(0, 0+hight, SCREEN_WIDTH, 180) placeholderImage:nil];
    _scrol.delegate =self;
    _scrol.timeInterval =2.0;
    [self addSubview:_scrol.view];
    
}
- (void)scrollImage:(ScrollImage *)scrollImage clickedAtIndex:(NSInteger)index{
    NSLog(@"&&&&&&%ld",(long)index);
    
    self.nav.hidesBottomBarWhenPushed=YES;
    BannerViewController *bannerVC=[[BannerViewController alloc]init];
    bannerVC.BannerUrl=self.linkArr[_scrol.pageControl.currentPage];
    [self.nav.navigationController pushViewController:bannerVC animated:YES];
    self.nav.hidesBottomBarWhenPushed=NO;
}

-(void)addAnnounceUI{
    _announceView = [[UIView alloc]init];
//    _announceView.backgroundColor=[UIColor whiteColor];
    _announceView.layer.masksToBounds=YES;
    _announceView.layer.cornerRadius=1;
    _announceView.layer.borderWidth=2;
    _announceView.layer.borderColor=[UIColor whiteSmoke].CGColor;
    _announceView.backgroundColor=[UIColor whiteColor];

    [self addSubview:_announceView];
    [_announceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(180+hight);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 75));
    }];
    NSMutableArray *labelTextArr=[NSMutableArray arrayWithObjects:@"热门商品",@"分组夺宝",@"十元专区",@"直购专区",@"推广有礼", nil];
    self.announceDatas=[NSMutableArray arrayWithObjects:@"list/index",@"list/index/ten/1",@"list/index/ten/5",@"ShopZg/plist",@"activity/activity/id/57", nil];
    int with = 46;
    int btnX = SCREEN_WIDTH/5;
    int btnY = 2;
    for (int i=0; i<5; i++) {
       
        UIButton * announceBtn =[[UIButton alloc]initWithFrame:CGRectMake(btnX*i+10, btnY+2, with, with)];
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"indextop%d",i]];
        [announceBtn setBackgroundImage:image forState:UIControlStateNormal];
        announceBtn.layer.cornerRadius=23;
        announceBtn.layer.masksToBounds=YES;
        announceBtn.tag=i;
        [announceBtn addTarget:self action:@selector(announceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_announceBtnArr addObject:announceBtn];
        [self.announceView addSubview:announceBtn];
        
        UILabel *announceLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnX*i+8, btnY+with-6, with+6, with-10)];
        announceLabel.text=labelTextArr[i];
        announceLabel.font=[UIFont systemFontOfSize:12];
        [self.announceView addSubview:announceLabel];
    }
}

-(void)announceBtnAction:(UIButton *)button{
    NSLog(@"点击了活动按钮%ld",button.tag);
    self.nav.hidesBottomBarWhenPushed=YES;
    ActionBarViewController *actionBarVC=[[ActionBarViewController alloc]init];
    actionBarVC.ActionBarUrl=self.announceDatas[button.tag];
    [self.nav.navigationController pushViewController:actionBarVC animated:YES];
    self.nav.hidesBottomBarWhenPushed=NO;

}

-(void)addNotificationUI{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 254+hight,SCREEN_WIDTH, 25)];
    NSLog(@"__________^^^%d",hight);
    view.layer.masksToBounds=YES;
    view.layer.cornerRadius=1;
    view.layer.borderWidth=1;
    view.layer.borderColor=[UIColor whiteSmoke].CGColor;
    view.backgroundColor=[UIColor whiteColor];
    [self addSubview:view];

    
    UIImageView * labaImageView=[[UIImageView alloc]initWithFrame:CGRectMake(7, 5, 20, 15)];
    labaImageView.image=[UIImage imageNamed:@"laba"];
    [view addSubview:labaImageView];
  
    _testView=[[UIView alloc]initWithFrame:CGRectMake(32, 2, SCREEN_WIDTH, 20)];

    [view addSubview:_testView];
    _ccpView = [[CCPScrollView alloc] initWithFrame:self.testView.bounds];
    _ccpView.BGColor = [UIColor clearColor];
    
    [_ccpView clickTitleLabel:^(NSInteger index,NSString *titleString) {
    
            NSLog(@"%ld-----%@",index,titleString);
    
            //自定义的弹出view
            UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 15 * 2, 200)];
    
           alertView.layer.masksToBounds=YES;
        
           alertView.layer.cornerRadius=10;
        
           alertView.layer.borderWidth=3;
        
           alertView.layer.borderColor=[UIColor whiteColor].CGColor;
        
           alertView.backgroundColor=[UIColor whiteColor];

        
            UILabel *alertLabel = [[UILabel alloc] init];
    
            alertLabel.textAlignment = NSTextAlignmentCenter;
    
            alertLabel.text = titleString;
    
            alertLabel.font = [UIFont systemFontOfSize:15];
        
            alertLabel.textColor=[UIColor blackColor];
        
            alertLabel.numberOfLines = 0;
    
            alertLabel.width =  [UIScreen mainScreen].bounds.size.width - 15 * 3;
            [alertLabel sizeToFit];
            alertLabel.centerX = alertView.centerX;
            alertLabel.centerY = alertView.centerY;
            [alertView addSubview:alertLabel];
            //弹出自定义弹窗
            CCPActionSheetView *actionSheetView = [[CCPActionSheetView alloc] initWithAlertView:alertView];
             actionSheetView.viewAnimateStyle = ViewAnimateScale;
    
        }];
    
     [_testView addSubview:_ccpView];
    
}
//-(void)setHbArr:(NSMutableArray *)hbArr{
//    _hbArr=hbArr;
////    for (HDModel *hb in _hbArr) {
////        _hbStr=[NSString stringWithFormat:@"%@%@",hb.nickname,hb.money];
////        NSLog(@"&&&&&&&&%@",_hbStr);
////        NSLog(@"%@",hb.money);
//   
// //}
//    
// }
-(void)uBtnAction:(UIButton*)btn{
    self.nav.hidesBottomBarWhenPushed=YES;
    ADetailsViewController *detailVC=[[ADetailsViewController alloc]init];
    detailVC.detailurl =_uUrlArr[btn.tag];
    [self.nav.navigationController pushViewController:detailVC animated:YES];
    self.nav.hidesBottomBarWhenPushed=NO;
}
//查看全部
-(void)btnAction{
   
}
-(void)setHbStr:(NSString *)hbStr{
    _hbStr=hbStr;
    _rollLabel.text = _hbStr;
}
//-(void)setOpen:(NSString *)open{
//    _open=open;
//    if ([_open intValue]==1) {
//        hight=30;
//        NSLog(@"++++++++_____________-%d",hight);
//    }
//}
//时间到了
-(void)timerLabel:(WB_Stopwatch*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    //NSLog(@"时间到了");
    [self.stopWatchLabel pause];
   _timeLabel.text=@"查看揭晓结果";
}

//开始倒计时
-(void)timerLabel:(WB_Stopwatch*)timerlabel
       countingTo:(NSTimeInterval)time
        timertype:(WB_StopwatchLabelType)timerType {
    // NSLog(@"time:%f",time);
    
}

-(void)setBData:(bannerData *)bData{
 
    _bData=bData;
    NSMutableArray *imageArr=[NSMutableArray array];
    NSMutableArray *lotteryArr=[NSMutableArray array];
    NSMutableArray *linkArr=[NSMutableArray array];
    for (silderMode *slider in _bData.slider) {
        [imageArr addObject:slider.imgUrl];
        [linkArr addObject:slider.link];

    }
    _imageArr=imageArr;
   
    _linkArr=linkArr;

    for (lotteryModel *lottery in _bData.lottery) {
        if (lottery.nickname==nil) {
            lottery.nickname=@"夺你所爱用户";
        }
        NSString *str=[NSString stringWithFormat:@"恭喜%@获得%@(%@期)",lottery.nickname,lottery.name,lottery.no];
        [lotteryArr addObject:str];
    }
    _lotteryArr=lotteryArr;
    if (!_scrol.view) {
        [self addGuideScollViewUI];
        [self addAnnounceUI];
        [self addNotificationUI];
        _ccpView.titleArray=_lotteryArr;
          NSLog(@"++++++++_____________%d",hight);
    }
   
}

@end
