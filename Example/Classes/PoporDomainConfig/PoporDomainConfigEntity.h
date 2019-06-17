//
//  PoporDomainConfigEntity.h
//  PoporDomainConfig_Example
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

#define PoporDCE(title, domain) [[PoporDomainConfigEntity alloc] initTitle:title withDomain:domain]

@protocol PoporDomainConfigEntity;
@interface PoporDomainConfigEntity : NSObject

@property (nonatomic, strong, nullable) NSString * title;
@property (nonatomic, strong) NSString * domain;

- (id)initTitle:(NSString *)title withDomain:(NSString *)domain;

@end

@interface PoporDomainConfigListEntity : NSObject

@property (nonatomic, strong) NSString  * title;
@property (nonatomic, strong) NSString  * key;
@property (nonatomic, strong) NSString  * domain;// 当前选择的域名
@property (nonatomic        ) int       titleW;// title 所占用的宽度
@property (nonatomic        ) NSInteger selectIndex;

@property (nonatomic, strong) NSMutableArray<PoporDomainConfigEntity> * array;

@end

NS_ASSUME_NONNULL_END
