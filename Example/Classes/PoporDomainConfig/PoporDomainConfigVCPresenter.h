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

// 初始化数据处理
- (void)setMyInteractor:(id)interactor;

// 很多操作,需要在设置了view之后才可以执行.
- (void)setMyView:(id)view;

@end
