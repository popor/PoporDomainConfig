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
#import <PoporFoundation/Block+pPrefix.h>

NS_ASSUME_NONNULL_BEGIN

@interface PoporDomainConfig : NSObject

// 一般推荐使用该数组
@property (nonatomic, strong) NSMutableArray<PoporDomainConfigListEntity *> * netArray;
@property (nonatomic, strong) NSString * defaultInfo;

+ (instancetype)share;

// 假如数组个数 <= 1,将隐藏infoCV.
+ (void)setNetDefaultArray:(NSMutableArray<PoporDomainConfigListEntity *> *)array defaultInfo:(NSString * _Nullable)info;

+ (void)restoreNetArrayAt:(NSInteger)index;

+ (void)updateDomain;

@end

NS_ASSUME_NONNULL_END
