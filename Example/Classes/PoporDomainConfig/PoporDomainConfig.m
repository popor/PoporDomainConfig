//
//  PoporDomainConfig.m
//  PoporDomainConfig_Example
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PoporDomainConfig.h"

#import <YYCache/YYCache.h>
#import <YYModel/YYModel.h>

#import "PoporDomainConfigCC.h"

static NSString * SaveKey = @"config";

@interface PoporDomainConfig ()
// 初始化的时候,或者清空列表的时候,需要这个数据.
// 初始化UI个数也需要这个数据.
@property (nonatomic, strong) NSMutableArray<PoporDomainConfigListEntity *> * netDefaultArray;

@property (nonatomic, strong) YYDiskCache * yyDiskCache;

@end

@implementation PoporDomainConfig

+ (instancetype)share {
    static dispatch_once_t once;
    static PoporDomainConfig * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        instance.netDefaultArray = [NSMutableArray<PoporDomainConfigListEntity *> new];
        instance.netArray = [NSMutableArray<PoporDomainConfigListEntity *> new];
       
        {
            NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
            basePath = [basePath stringByAppendingPathComponent:@"YYCache_PoporDomainConfig"];
            
            YYDiskCache *yyDiskCache;
            yyDiskCache   = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:SaveKey]];
            
            yyDiskCache.customArchiveBlock = ^NSData * _Nonnull(id  _Nonnull object) {
                NSArray * array = (NSArray *)object;
                return [array yy_modelToJSONData];
            };
            
            yyDiskCache.customUnarchiveBlock = ^id _Nonnull(NSData * _Nonnull data) {
                // https://blog.csdn.net/qw656567/article/details/52367618
                
                id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSMutableArray * mArray = [NSMutableArray new];
                NSArray *array = (NSArray *)jsonObject;
                for (id oneID in array) {
                    [mArray addObject:[PoporDomainConfigListEntity yy_modelWithDictionary:oneID]];
                }
                return mArray;
            };
            
            instance.yyDiskCache = yyDiskCache;
        }
        
        
    });
    return instance;
}

+ (void)setNetDefaultArray:(NSMutableArray<PoporDomainConfigListEntity *> *)array {
    PoporDomainConfig * config = [PoporDomainConfig share];
    config.netDefaultArray = array;
    
    config.netArray = (NSMutableArray *)[config.yyDiskCache objectForKey:SaveKey];
    
    // 判断是否需要更新NetArray
    if (!config.netArray ||
        config.netArray.count != array.count) {
        config.netArray = array.mutableCopy;
        
        [self updateLeTitleW];
        [self updateDomain];
        
    }else{
        BOOL isNeedUpdate = NO;
        for (int i = 0; i<array.count; i++) {
            PoporDomainConfigListEntity * leDefault = config.netDefaultArray[i];
            PoporDomainConfigListEntity * leCurrent = config.netArray[i];
            
            if (![leDefault.key isEqualToString:leCurrent.key] ||
                ![leDefault.title isEqualToString:leCurrent.title] ) {
                isNeedUpdate = YES;
                break;
            }
        }
        [self updateLeTitleW];
        [self updateDomain];
    }

}

+ (void)updateLeTitleW {
    PoporDomainConfig * config = [PoporDomainConfig share];
    for (int i = 0; i<config.netArray.count; i++) {
        PoporDomainConfigListEntity * leCurrent = config.netArray[i];
        leCurrent.titleW = [PoporDomainConfigCC cellW:leCurrent.title];
    }
}

+ (void)updateDomain {
    PoporDomainConfig * config = [PoporDomainConfig share];
    [config.yyDiskCache setObject:config.netArray forKey:SaveKey];
}

@end
