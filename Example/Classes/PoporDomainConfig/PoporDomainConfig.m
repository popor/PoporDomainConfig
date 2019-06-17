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
                    PoporDomainConfigListEntity * le = [PoporDomainConfigListEntity yy_modelWithDictionary:oneID];
                    
                    [mArray addObject:le];
                }
                return mArray;
            };
            
            instance.yyDiskCache = yyDiskCache;
        }
        
        
    });
    return instance;
}

+ (void)setNetDefaultArray:(NSMutableArray<PoporDomainConfigListEntity *> *)array defaultInfo:(NSString * _Nullable)info {
    
    PoporDomainConfig * config = [PoporDomainConfig share];
    config.netDefaultArray = array;
    config.defaultInfo     = info ? : @"域名修改只对debug版本APP有效";
    
    
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
        // 发生了变更,需要刷新默认数据
        if (isNeedUpdate) {
            config.netArray = array.mutableCopy;
            [self updateLeTitleW];
            [self updateDomain];
        }
    }

}

+ (void)updateLeTitleW {
    int totalW = 0;
    PoporDomainConfig * config = [PoporDomainConfig share];
    if (config.netArray.count == 0) {
        return;
    }
    for (int i = 0; i<config.netArray.count; i++) {
        PoporDomainConfigListEntity * leCurrent = config.netArray[i];
        leCurrent.titleW = [PoporDomainConfigCC cellW:leCurrent.title];
        totalW += leCurrent.titleW;
    }
    
    // 检查是不是少容量的文字
    int maxW = [[UIScreen mainScreen] bounds].size.width - PoporDomainConfigVCXGap*2;
    if (totalW + config.netArray.count*PoporDomainConfigCvXyGap <= maxW) {
        int w = maxW/config.netArray.count;
        for (int i = 0; i<config.netArray.count; i++) {
            PoporDomainConfigListEntity * leCurrent = config.netArray[i];
            leCurrent.titleW = w - PoporDomainConfigCvXyGap;
        }
    }
}

+ (void)updateDomain {
    PoporDomainConfig * config = [PoporDomainConfig share];
    [config.yyDiskCache setObject:config.netArray forKey:SaveKey];
}

@end
