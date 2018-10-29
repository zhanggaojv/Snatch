//
//  BannerViewController.h
//  Snatch
//
//  Created by Zhanggaoju on 16/9/30.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerViewController : UIViewController

@property (nonatomic,strong) NSString *BannerUrl;

@property (nonatomic,strong) NSString *token;

@property (nonatomic,strong) NSString *link;

@property (nonatomic,strong) NSString *imageurl;

@property (nonatomic,strong) NSString *titles;

@property (strong,nonatomic) NSString *dataStr;

@property (nonatomic,strong) NSDictionary *data;

@property (nonatomic,strong) NSDictionary *Qdata;
@end
