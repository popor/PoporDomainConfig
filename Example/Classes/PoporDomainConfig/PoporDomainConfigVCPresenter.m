//
//  PoporDomainConfigVCPresenter.m
//  PoporDomainConfig
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.

#import "PoporDomainConfigVCPresenter.h"
#import "PoporDomainConfigVCInteractor.h"

#import "PoporDomainConfig.h"
#import "PoporDomainConfigCC.h"

#import <PoporFoundation/NSString+pSize.h>
#import <PoporFoundation/NSString+pAtt.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import <PoporUI/IToastPTool.h>

@interface PoporDomainConfigVCPresenter ()

@property (nonatomic, weak  ) id<PoporDomainConfigVCProtocol> view;
@property (nonatomic, strong) PoporDomainConfigVCInteractor * interactor;

@property (nonatomic, weak  ) PoporDomainConfig * domainConfig;
//@property (nonatomic, weak  ) PoporDomainConfigListEntity * weakListEntity;
@property (nonatomic, strong) UIFont * cellFont;
@property (nonatomic        ) int screenW;

@end

@implementation PoporDomainConfigVCPresenter

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

// 初始化数据处理
- (void)setMyInteractor:(PoporDomainConfigVCInteractor *)interactor {
    self.interactor = interactor;
}

// 很多操作,需要在设置了view之后才可以执行.
- (void)setMyView:(id<PoporDomainConfigVCProtocol>)view {
    self.view = view;
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    self.domainConfig = [PoporDomainConfig share];
    self.cellFont     = [UIFont systemFontOfSize:16];
    self.screenW      = self.view.vc.view.frame.size.width;
    
}

#pragma mark - VC_DataSource
- (PoporDomainConfigListEntity *)listEntity {
    if (self.interactor.cvSelectIndex < 0) {
        return self.domainConfig.netArray.firstObject;
    }else{
        return self.domainConfig.netArray[self.interactor.cvSelectIndex];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.domainConfig.netArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PoporDomainConfigCC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PoporDomainConfigCCKey forIndexPath:indexPath];
    PoporDomainConfigListEntity * le = self.domainConfig.netArray[indexPath.row];
    cell.titleL.text = le.title;
    if (self.interactor.cvSelectIndex == -1) {
        if (indexPath.row == 0) {
            cell.selected = YES;
            self.interactor.cvSelectIndex = 0;
            [self selectCvIndex:self.interactor.cvSelectIndex];
        }
    }
    return cell;
}

#pragma layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PoporDomainConfigListEntity * le = self.domainConfig.netArray[indexPath.row];
    return CGSizeMake(le.titleW, PoporDomainConfigCCHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 1, 0, 1);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return PoporDomainConfigCvXyGap;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return PoporDomainConfigCvXyGap;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != self.interactor.cvSelectIndex) {
        
        PoporDomainConfigCC *cell = (PoporDomainConfigCC *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setSelected:YES];
        cell = (PoporDomainConfigCC *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.interactor.cvSelectIndex inSection:0]];
        [cell setSelected:NO];
        self.interactor.cvSelectIndex = indexPath.row;
        
        [self selectCvIndex:self.interactor.cvSelectIndex];
    }
    
}

#pragma mark - TV_Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listEntity.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PoporDomainConfigEntity * entity = self.listEntity.array[indexPath.row];

    CGFloat height = [entity.domain sizeInFont:self.cellFont width:self.screenW- 34].height + 14;
    return MAX(height, 50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellID = @"CellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = self.cellFont;
    }
    PoporDomainConfigEntity * entity = self.listEntity.array[indexPath.row];
    
    if (entity.title) {
        NSMutableAttributedString * att = [NSMutableAttributedString new];
        [att addString:[NSString stringWithFormat:@"%@: ", entity.title] font:nil color:[UIColor blackColor]];
        [att addString:entity.domain font:nil color:[UIColor lightGrayColor]];
        cell.textLabel.attributedText = att;
    }else{
        cell.textLabel.text = entity.domain;
    }
    
    if (self.listEntity.selectIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    PoporDomainConfigEntity * entity = self.listEntity.array[indexPath.row];
    
    {
        @weakify(self);
        NSMutableArray * actionArray = [[NSMutableArray alloc] init];
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            @strongify(self);
            
            if (self.listEntity.selectIndex == indexPath.row) {
                self.listEntity.selectIndex = -1;
            } else if (self.listEntity.selectIndex > indexPath.row){
                self.listEntity.selectIndex --;
            }
            [self.listEntity.array removeObjectAtIndex:indexPath.row];
            if (self.listEntity.array.count == 0) {
                if (self.interactor.cvSelectIndex == -1) {
                    self.interactor.cvSelectIndex = 0;
                }
                AlertToastTitle(@"恢复默认数据");
                [PoporDomainConfig restoreNetArrayAt:self.interactor.cvSelectIndex];
            }
            [PoporDomainConfig updateDomain];
            [self.view.infoTV reloadData];
        }];
        deleteRowAction.backgroundColor = [UIColor redColor];
        
        UITableViewRowAction *titleRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"设置标题" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            {
                @strongify(self);
                UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:@"修改" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
                    
                    textField.placeholder = @"请设置标题";
                    textField.text = entity.title ? : @"";
                }];
                
                UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction * changeAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    @strongify(self);
                    
                    UITextField * nameTF = oneAC.textFields[0];
                    entity.title = nameTF.text;
                    
                    [PoporDomainConfig updateDomain];
                    [self.view.infoTV reloadData];
                }];
                
                [oneAC addAction:cancleAction];
                [oneAC addAction:changeAction];
                
                [self.view.vc presentViewController:oneAC animated:YES completion:nil];
            }
        }];
        titleRowAction.backgroundColor = [UIColor lightGrayColor];
        
        UITableViewRowAction *domainRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"更新域名" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            {
                @strongify(self);
                
                UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:@"更新域名" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
                    
                    textField.placeholder = @"更新域名";
                    textField.text = entity.domain ? : @"";
                }];
                
                UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction * changeAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    @strongify(self);
                    
                    UITextField * nameTF = oneAC.textFields[0];
                    entity.domain = nameTF.text;
                    
                    [PoporDomainConfig updateDomain];
                    [self.view.infoTV reloadData];
                }];
                
                [oneAC addAction:cancleAction];
                [oneAC addAction:changeAction];
                
                [self.view.vc presentViewController:oneAC animated:YES completion:nil];
            }
        }];
        domainRowAction.backgroundColor = [UIColor grayColor];
        
        
        [actionArray addObject:deleteRowAction];
        [actionArray addObject:domainRowAction];
        [actionArray addObject:titleRowAction];
        
        
        return actionArray;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != self.listEntity.selectIndex) {
        UITableViewCell * cellOld = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.listEntity.selectIndex inSection:0]];
        UITableViewCell * cellNew = [tableView cellForRowAtIndexPath:indexPath];
        
        cellOld.accessoryType = UITableViewCellAccessoryNone;
        cellNew.accessoryType = UITableViewCellAccessoryCheckmark;
        
        PoporDomainConfigEntity * entity = self.listEntity.array[indexPath.row];
        
        self.listEntity.domain = entity.domain;
        self.view.defaultUrlTF.text = self.listEntity.domain;
        self.listEntity.selectIndex = indexPath.row;
        
        [PoporDomainConfig updateDomain];
    }
}

#pragma mark - Interactor_EventHandler
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        textField.text = @"http://";
    });
    return YES;
}

#pragma mark - VC_EventHandler
- (void)saveAction {
    
    {
        @weakify(self);
        
        UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:@"新增" message:@"请设置标题" preferredStyle:UIAlertControllerStyleAlert];
        
        [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
            
            textField.placeholder = @"标题";
            textField.text = @"";
        }];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * changeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            
            UITextField * nameTF = oneAC.textFields[0];
            
            PoporDomainConfigEntity * entity = [PoporDomainConfigEntity new];
            if (nameTF.text.length == 0) {
                entity.title  = nil;
            }else{
                entity.title  = nameTF.text;
            }
            
            entity.domain = self.view.defaultUrlTF.text;
            
            self.listEntity.selectIndex = self.listEntity.array.count;
            [self.listEntity.array addObject:entity];
            
            [PoporDomainConfig updateDomain];
            
            [self.view.infoTV reloadData];
            [self.view.infoTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.listEntity.array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }];
        
        [oneAC addAction:cancleAction];
        [oneAC addAction:changeAction];
        
        [self.view.vc presentViewController:oneAC animated:YES completion:nil];
    }
}

- (void)selectCvIndex:(NSInteger)index {
    self.view.defaultUrlTF.text = self.listEntity.domain;
    [self.view.infoTV reloadData];
    
    if (self.listEntity.selectIndex >= 0 && self.listEntity.selectIndex < self.listEntity.array.count) {
        [self.view.infoTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.listEntity.selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    }
}

#pragma mark - Interactor_EventHandler

@end
