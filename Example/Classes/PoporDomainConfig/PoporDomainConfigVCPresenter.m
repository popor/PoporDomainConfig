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

#import <PoporFoundation/NSString+Size.h>
#import <PoporFoundation/NSString+format.h>
#import <ReactiveObjC/ReactiveObjC.h>

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
        [self initInteractors];
    }
    return self;
}

// 一般由present初始化使用或者继承使用.
- (void)initInteractors {
    if (!self.interactor) {
        self.interactor = [PoporDomainConfigVCInteractor new];
    }
}

// 很多操作,需要在设置了view之后才可以执行.
- (void)setMyView:(id<PoporDomainConfigVCProtocol>)view {
    self.view = view;
    self.domainConfig = [PoporDomainConfig share];
    self.cellFont     = [UIFont systemFontOfSize:16];
    self.screenW      = self.view.vc.view.frame.size.width;
    
}

#pragma mark - VC_DataSource
- (PoporDomainConfigListEntity *)listEntity {
    return self.domainConfig.netArray[self.view.segmenteControl.selectedSegmentIndex];
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
    cell.titleL.text = self.listEntity.title;
    
    return cell;
}

#pragma layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.listEntity.titleW, PoporDomainConfigCCHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
    return 10;
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
    
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    PoporDomainConfigEntity * entity = self.listEntity.array[indexPath.row];
    
    {
        @weakify(self);
        NSMutableArray * actionArray = [[NSMutableArray alloc] init];
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            @strongify(self);
            
            [self.listEntity.array removeObjectAtIndex:indexPath.row];
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
                    //NSLog(@"更新 name: %@", nameTF.text);
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
                    //NSLog(@"更新 name: %@", nameTF.text);
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
    
    PoporDomainConfigEntity * entity = self.listEntity.array[indexPath.row];
    
    self.listEntity.domain = entity.domain;
    
    [PoporDomainConfig updateDomain];
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
    
    
}

- (void)selectSegmentedItem:(UISegmentedControl *)sender {
    
    [self.view.infoTV reloadData];
    
}


#pragma mark - Interactor_EventHandler

@end
