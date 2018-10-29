//
//  RedEnvelopeViewController.h
//  Snatch
//
//  Created by Zhanggaoju on 16/10/7.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义协议与方法
@protocol DeliverDetegate <NSObject>

- (void)setValue:(NSString *)string;

@end

@protocol hbidDetegate <NSObject>

- (void)hbidsetValue:(NSString *)string;

@end

@interface RedEnvelopeViewController : UIViewController

@property (nonatomic,strong) NSString *token;

@property (nonatomic,strong) NSString *yfprice;

//声明委托变量
@property (weak,nonatomic) id<DeliverDetegate>money_Delegate;

@property (weak,nonatomic) id<hbidDetegate>hbid_Delegate;

@end
