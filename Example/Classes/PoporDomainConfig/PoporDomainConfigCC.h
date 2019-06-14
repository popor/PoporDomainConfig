//
//  PoporDomainConfigCC.h
//  PoporDomainConfig_Example
//
//  Created by apple on 2019/6/14.
//  Copyright © 2019 popor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * PoporDomainConfigCCKey = @"PoporDomainConfigCC";
static int PoporDomainConfigCCHeight = 40;

@interface PoporDomainConfigCC : UICollectionViewCell

@property (nonatomic, strong) UILabel * titleL;

+ (int)cellW:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
