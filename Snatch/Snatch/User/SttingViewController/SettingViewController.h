//
//  SettingViewController.h
//  Snatch
//
//  Created by Zhanggaoju on 16/10/9.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController

@property (nonatomic,strong) NSString *token;

@property (nonatomic,strong) NSDictionary *SystemInfoData;

@property (nonatomic, assign) CGFloat fileSize;

@property (nonatomic,strong) NSString *version;

@property (nonatomic) float cacheSize;

@property (nonatomic,strong) NSString *cacheSizeStr;
@end
