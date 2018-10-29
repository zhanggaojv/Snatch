//
//  GJRefreshFooter.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/5.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "GJRefreshFooter.h"

@implementation GJRefreshFooter

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 0; i < 28; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%d", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:3];
    
    //隐藏状态
    self.refreshingTitleHidden = YES;
    self.stateLabel.hidden = YES;
}

@end
