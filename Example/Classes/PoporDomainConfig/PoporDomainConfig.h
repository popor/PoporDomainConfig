//
//  PoporDomainConfig.h
//  PoporDomainConfig_Example
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PoporDomainConfigEntity.h"
#import "PoporDomainConfigVC.h"
#import <PoporFoundation/PrefixBlock.h>

NS_ASSUME_NONNULL_BEGIN

@interface PoporDomainConfig : NSObject

// 一般推荐使用该数组
@property (nonatomic, strong) NSMutableArray<PoporDomainConfigListEntity *> * netArray;

+ (instancetype)share;
//- (NSString *)domain
+ (void)setNetDefaultArray:(NSMutableArray<PoporDomainConfigListEntity *> *)array;

+ (void)updateDomain;

@end

NS_ASSUME_NONNULL_END
