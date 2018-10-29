//
//  GJButton.h
//  Snatch
//
//  Created by Zhanggaoju on 2016/10/19.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJButton : UIButton

- (GJButton *)buttonWithAboveLabelTitle:(NSString *)aStr belowLabelTitle:(NSString *)bStr;
/** aboveLabel */
@property (nonatomic, weak) UILabel *aboveL;
/** belowLabel */
@property (nonatomic, weak) UILabel *belowL;

@end
