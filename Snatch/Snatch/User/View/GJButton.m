//
//  GJButton.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/10/19.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "GJButton.h"

#define ABColor(R, G, B, Alpha) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(Alpha)]


@implementation GJButton

- (GJButton *)buttonWithAboveLabelTitle:(NSString *)aStr belowLabelTitle:(NSString *)bStr {
    
    UILabel *aboveL = [[UILabel alloc] init];
    aboveL.text = aStr;
    aboveL.font = [UIFont systemFontOfSize:18.0];
    //aboveL.textColor = ABColor(21, 135, 228, 1.0);
    aboveL.textColor=[UIColor lightSeaGreen];
    aboveL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:aboveL];
    self.aboveL = aboveL;
    
    UILabel *belowL = [[UILabel alloc] init];
    belowL.text = bStr;
    belowL.font = [UIFont systemFontOfSize:14.0];
    //belowL.textColor = ABColor(78, 157, 232, 1.0);
    belowL.textColor=[UIColor lightSeaGreen];
    belowL.textColor=[UIColor redColor];
    belowL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:belowL];
    self.belowL = belowL;
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.size = CGSizeMake((SCREEN_WIDTH-60)/3, 50);
//        self.layer.borderColor = ABColor(21, 135, 228, 1.0).CGColor;
        self.layer.borderColor =[UIColor lightSeaGreen].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5.0f;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.aboveL.frame = CGRectMake(0, 0, self.width, 50);
    self.belowL.frame = CGRectMake(0, CGRectGetMaxY(self.aboveL.frame), self.width, 20);
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    //self.backgroundColor = ABColor(56, 145, 230, 0.9);
    self.backgroundColor=[UIColor lightSeaGreen];
    self.aboveL.textColor = [UIColor whiteColor];
    self.belowL.textColor = [UIColor whiteColor];
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.backgroundColor = selected ? [UIColor lightSeaGreen] : [UIColor whiteColor];
    self.aboveL.textColor = selected ? [UIColor whiteColor] : [UIColor lightSeaGreen];
    self.belowL.textColor = selected ? [UIColor whiteColor] : [UIColor lightSeaGreen];
    
}
- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (!enabled) {
        self.aboveL.textColor = [UIColor lightGrayColor];
        self.belowL.textColor = [UIColor lightGrayColor];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.cornerRadius = 5.0f;
    }
}
@end


