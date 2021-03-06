//
//  PoporDomainConfigEntity.h
//  PoporDomainConfig_Example
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

// 为了方便第三方实用,将PoporDomainConfigEntity、PoporDomainConfigListEntity的继承改为PoporJsonModel。

#import <PoporJsonModel/PoporJsonModel.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

#define PoporDCE(title, domain) [[PoporDomainConfigEntity alloc] initTitle:title withDomain:domain]

@protocol PoporDomainConfigEntity;
@interface PoporDomainConfigEntity : PoporJsonModel

@property (nonatomic, strong, nullable) NSString * title;
@property (nonatomic, strong) NSString * domain;

- (id)initTitle:(NSString *)title withDomain:(NSString *)domain;

@end

@interface PoporDomainConfigListEntity : PoporJsonModel

@property (nonatomic, strong) NSString  * title; // 更改名字之后,将全部更新.
@property (nonatomic, strong) NSString  * domain;// 当前选择的域名
@property (nonatomic        ) int       titleW;// title 所占用的宽度
@property (nonatomic        ) NSInteger selectIndex;

@property (nonatomic, strong) NSMutableArray<PoporDomainConfigEntity> * array;

@end

NS_ASSUME_NONNULL_END
