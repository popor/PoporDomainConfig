//
//  PoporDomainConfigEntity.m
//  PoporDomainConfig_Example
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PoporDomainConfigEntity.h"

@implementation PoporDomainConfigEntity

- (id)initTitle:(NSString *)title withDomain:(NSString *)domain {
    if (self = [super init]) {
        _title = title;
        _domain = domain;
    }
    return self;
}

@end

@implementation PoporDomainConfigListEntity

- (id)init {
    if (self = [super init]) {
        _array = [NSMutableArray<PoporDomainConfigEntity *> new];
    }
    return self;
}

@end
