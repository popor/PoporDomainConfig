//
//  PoporDomainConfigVC.h
//  PoporDomainConfig
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.

#import <UIKit/UIKit.h>
#import "PoporDomainConfigVCProtocol.h"

@interface PoporDomainConfigVC : UIViewController <PoporDomainConfigVCProtocol>

- (instancetype)initWithDic:(NSDictionary *)dic;

- (void)addViews;

// 开始执行事件,比如获取网络数据
- (void)startEvent;

@end
