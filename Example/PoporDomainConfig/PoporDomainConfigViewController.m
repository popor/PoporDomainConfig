//
//  PoporDomainConfigViewController.m
//  PoporDomainConfig
//
//  Created by popor on 06/12/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import "PoporDomainConfigViewController.h"

#import "PoporDomainConfig.h"
#import <PoporFoundation/NSMutableArray+pChain.h>
@interface PoporDomainConfigViewController ()

@end

@implementation PoporDomainConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        // config
        //PoporDomainConfig * config = [PoporDomainConfig share];
        NSMutableArray * array = [NSMutableArray new];

        
        array.add([self getBaiduEntity]);
        array.add([self getBingEntity]);
        array.add([self getGoogleEntity]);
        
        //        array.add([self getGoogleEntity]);
        //        array.add([self getGoogleEntity]);
        //        array.add([self getGoogleEntity]);
        //        array.add([self getGoogleEntity]);
        //        array.add([self getGoogleEntity]);
        //        array.add([self getGoogleEntity]);
        //        array.add([self getGoogleEntity]);
        
        [PoporDomainConfig setNetDefaultArray:array defaultInfo:nil];
    }
    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"域名配置" style:UIBarButtonItemStylePlain target:self action:@selector(action1)];
        self.navigationItem.rightBarButtonItems = @[item1];
    }
}

- (PoporDomainConfigListEntity *)getBaiduEntity {
    PoporDomainConfigListEntity * entity = [PoporDomainConfigListEntity new];
    entity.title  = @"百度";
    entity.domain = @"https://www.baidu.com/dev";
    entity.selectIndex = 0;
    
    entity.array
    .add(PoporDCE(@"开发", @"https://www.baidu.com/dev"))
    .add(PoporDCE(@"测试", @"https://www.baidu.com/test"))
    .add(PoporDCE(@"正式", @"https://www.baidu.com/release"));
    
    return entity;
}

- (PoporDomainConfigListEntity *)getBingEntity {
    PoporDomainConfigListEntity * entity = [PoporDomainConfigListEntity new];
    entity.title  = @"必应";
    entity.domain = @"https://cn.bing.com/dev";
    entity.selectIndex = 0;
    
    entity.array
    .add(PoporDCE(@"开发", @"https://cn.bing.com/dev"))
    .add(PoporDCE(@"测试", @"https://cn.bing.com/test"))
    .add(PoporDCE(@"正式", @"https://cn.bing.com/release"));
    
    return entity;
}

- (PoporDomainConfigListEntity *)getGoogleEntity {
    PoporDomainConfigListEntity * entity = [PoporDomainConfigListEntity new];
    entity.title  = @"谷歌";
    entity.domain = @"https://www.google.com/dev";
    entity.selectIndex = 0;
    
    entity.array
    .add(PoporDCE(@"开发", @"https://www.google.com/dev"))
    .add(PoporDCE(@"测试", @"https://www.google.com/test"))
    .add(PoporDCE(@"正式", @"https://www.google.com/release"));
    
    return entity;
}

- (void)action1 {
    NSDictionary * dic;
    dic = @{
            
            };
    [self.navigationController pushViewController:[[PoporDomainConfigVC alloc] initWithDic:dic] animated:YES];
}

@end
