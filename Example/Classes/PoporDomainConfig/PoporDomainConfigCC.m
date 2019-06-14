//
//  PoporDomainConfigCC.m
//  PoporDomainConfig_Example
//
//  Created by apple on 2019/6/14.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PoporDomainConfigCC.h"

#import <Masonry/Masonry.h>

#import <PoporFoundation/NSString+Size.h>

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
        //l.frame              = CGRectMake(0, 0, 0, 44);
        l.backgroundColor    = [UIColor clearColor];
        l.font               = [UIFont systemFontOfSize:15];
        l.textColor          = [UIColor darkGrayColor];
        
        l.numberOfLines      = 1;
        
        l.layer.cornerRadius = 5;
        l.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        l.layer.borderWidth  = 1;
        l.clipsToBounds      = YES;
        
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
    
    self.backgroundColor = [UIColor redColor];
}

+ (int)cellW:(NSString *)str {
    static UIFont * font;
    if (!font) {
        font = [UIFont systemFontOfSize:15];
    }
    CGSize size = [str sizeInFont:font];
    return size.width + 14;
}

@end
