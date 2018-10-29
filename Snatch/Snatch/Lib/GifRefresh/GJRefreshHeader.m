//
//  refreshGifHeader.m
//  Snatch
//
//  Created by Zhanggaoju on 16/9/29.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "GJRefreshHeader.h"

@implementation GJRefreshHeader
#define MJIDLE MJRefreshStateIdle
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    //设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    UIImage *imageBegin = [UIImage imageNamed:@"pullRefresh"];
    [idleImages addObject:imageBegin];
    [self setImages:idleImages forState:1];
    
    
    //设置即将刷新的图片
    NSMutableArray *pullImages = [NSMutableArray array];
    UIImage *imagePull = [UIImage imageNamed:@"loading"];
    [pullImages addObject:imagePull];
    [self setImages:pullImages forState:2];
    
    //设置正在刷新状态的动画图片
    NSMutableArray *refreshImages = [NSMutableArray array];
    for (NSUInteger i = 0; i < 29; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%ld",i]];
        [refreshImages addObject:image];
    }
    
    [self setImages:refreshImages forState:3];
    
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    
    //隐藏状态
    self.stateLabel.hidden = YES;
    
    //设置高度
    self.mj_h = 80;

}

@end
