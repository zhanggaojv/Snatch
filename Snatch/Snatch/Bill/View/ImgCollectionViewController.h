//
//  ImgCollectionViewController.h
//  Snatch
//
//  Created by 袁伟森 on 2016/10/20.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillModel.h"

@interface ImgCollectionViewController : UIViewController
@property (nonatomic,strong) NSArray *picArr;
@property (nonatomic,strong) BillModel *bModels;
@property (nonatomic,strong) UICollectionView *collectionView;

@end
