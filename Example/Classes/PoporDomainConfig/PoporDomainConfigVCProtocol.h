//
//  PoporDomainConfigVCProtocol.h
//  PoporDomainConfig
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.

#import <UIKit/UIKit.h>

#import <PoporUI/UITextField+pInsets.h>

static int PoporDomainConfigVCXGap  = 20;
static int PoporDomainConfigCvXyGap = 1; // 左右上下间隔

// MARK: 对外接口
@protocol PoporDomainConfigVCProtocol <NSObject>

- (UIViewController *)vc;

// MARK: 自己的
@property (nonatomic, strong) UITextField * defaultUrlTF;
@property (nonatomic, strong) UIButton    * saveBT;
@property (nonatomic, strong) UITableView * infoTV;
@property (nonatomic, strong) UICollectionView * infoCV;

// MARK: 外部注入的

@end

// MARK: 数据来源
@protocol PoporDomainConfigVCDataSource <NSObject>

@end

// MARK: UI事件
@protocol PoporDomainConfigVCEventHandler <NSObject>

- (void)saveAction;

@end
