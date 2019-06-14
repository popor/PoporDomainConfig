//
//  PoporDomainConfigVCProtocol.h
//  PoporDomainConfig
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.

#import <UIKit/UIKit.h>

#import <PoporUI/UIInsetsTextField.h>

// MARK: 对外接口
@protocol PoporDomainConfigVCProtocol <NSObject>

- (UIViewController *)vc;

// MARK: 自己的
@property (nonatomic, strong) UISegmentedControl *segmenteControl;
@property (nonatomic, strong) UIInsetsTextField * defaultUrlTF;
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
- (void)selectSegmentedItem:(UISegmentedControl *)sender;

@end
