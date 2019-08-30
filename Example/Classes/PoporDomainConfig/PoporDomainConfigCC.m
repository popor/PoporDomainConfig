//
//  PoporDomainConfigCC.m
//  PoporDomainConfig_Example
//
//  Created by apple on 2019/6/14.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PoporDomainConfigCC.h"

#import <Masonry/Masonry.h>

#import <PoporFoundation/NSString+pSize.h>

@implementation PoporDomainConfigCC

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addViews];
    }
    
    return self;
}

- (void)addViews {
    self.titleL = ({
        UILabel * l = [UILabel new];
        l.backgroundColor = [UIColor clearColor];
        l.font            = PoporDomainConfigCCFont;
        l.textColor       = [UIColor darkGrayColor];
        l.textAlignment   = NSTextAlignmentCenter;
        
        [self addSubview:l];
        l;
    });
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.right.mas_equalTo(-7);
        //make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self.titleL.font.pointSize + 3);
    }];
    
     self.backgroundColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleL.textColor = [UIColor whiteColor];
    }else{
        self.titleL.textColor = [UIColor darkGrayColor];
    }
}

+ (int)cellW:(NSString *)str {
    static UIFont * font;
    if (!font) {
        font = PoporDomainConfigCCFont;
    }
    CGSize size = [str sizeInFont:font];
    return size.width + 14;
}

@end
