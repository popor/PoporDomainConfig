//
//  PoporDomainConfigVCPresenter.h
//  PoporDomainConfig
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.

#import <Foundation/Foundation.h>
#import "PoporDomainConfigVCProtocol.h"

// 处理和View事件
@interface PoporDomainConfigVCPresenter : NSObject <PoporDomainConfigVCEventHandler, PoporDomainConfigVCDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

- (void)setMyInteractor:(id)interactor;

- (void)setMyView:(id)view;

// 开始执行事件,比如获取网络数据
- (void)startEvent;

@end
