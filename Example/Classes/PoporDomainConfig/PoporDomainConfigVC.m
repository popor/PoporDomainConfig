//
//  PoporDomainConfigVC.m
//  PoporDomainConfig
//
//  Created by apple on 2019/6/12.
//  Copyright © 2019 popor. All rights reserved.

#import "PoporDomainConfigVC.h"
#import "PoporDomainConfigVCPresenter.h"

#import "PoporDomainConfig.h"
#import "PoporDomainConfigCC.h"

#import <PoporUI/UIViewController+TapEndEdit.h>
#import <PoporUI/UIImage+create.h>
#import <PoporUI/UINavigationController+Size.h>
#import <Masonry/Masonry.h>

@interface PoporDomainConfigVC ()

@property (nonatomic, strong) PoporDomainConfigVCPresenter * present;

@end

@implementation PoporDomainConfigVC
@synthesize defaultUrlTF;
@synthesize saveBT;
@synthesize infoTV;
@synthesize infoCV;

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        if (dic) {
            self.title = dic[@"title"];
        }
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startMonitorTapEdit];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopMonitorTapEdit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.title) {
        self.title = @"域名配置";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.present) {
        PoporDomainConfigVCPresenter * present = [PoporDomainConfigVCPresenter new];
        self.present = present;
        [present setMyView:self];
    }
    
    [self addViews];
    [self addTapEndEditGRAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 参考: https://www.jianshu.com/p/c244f5930fdf
    if (self.isViewLoaded && !self.view.window) {
        // self.view = nil;//当再次进入此视图中时能够重新调用viewDidLoad方法
        
    }
}

#pragma mark - VCProtocol
- (UIViewController *)vc {
    return self;
}

#pragma mark - views
- (void)addViews {
    self.infoCV = [self addCV];
    
    PoporDomainConfig * pdConfig = [PoporDomainConfig share];
    NSMutableArray * titleArray = [NSMutableArray new];
    for (PoporDomainConfigListEntity * le in pdConfig.netArray) {
        [titleArray addObject:le.title];
    }

    if (!self.defaultUrlTF) {
        UIInsetsTextField * tf = [[UIInsetsTextField alloc] initWithFrame:CGRectZero insets:UIEdgeInsetsMake(0, 5, 0, 5)];
        tf.backgroundColor = [UIColor whiteColor];
        tf.font            = [UIFont systemFontOfSize:16];
        
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        tf.layer.cornerRadius = 5;
        tf.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        tf.layer.borderWidth  = 1;
        tf.clipsToBounds      = YES;
        
        tf.delegate           = self.present;
        
        [self.view addSubview:tf];
        self.defaultUrlTF = tf;
    }
    
    self.saveBT = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =  CGRectMake(100, 100, 80, 44);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:@"新增" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageFromColor:self.view.tintColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        
        [self.view addSubview:button];
        
        [button addTarget:self.present action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    
    UILabel * infoL = ({
        UILabel * l = [UILabel new];
        l.frame              = CGRectMake(0, 0, 0, 44);
        l.backgroundColor    = [UIColor clearColor];
        l.font               = [UIFont systemFontOfSize:15];
        l.textColor          = [UIColor darkGrayColor];
        l.textAlignment      = NSTextAlignmentCenter;
        
        [self.view addSubview:l];
        
        l.text = pdConfig.defaultInfo;
        
        [l setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        l.numberOfLines =0;
        
        l;
    });
    
    [self.defaultUrlTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PoporDomainConfigVCXGap);
        make.top.mas_equalTo(self.infoCV.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(-PoporDomainConfigVCXGap);
        make.height.mas_equalTo(44);
    }];
    [self.saveBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PoporDomainConfigVCXGap);
        make.top.mas_equalTo(self.defaultUrlTF.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(-PoporDomainConfigVCXGap);
        make.height.mas_equalTo(44);
    }];
    
    [infoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.saveBT.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(-20);
        //make.height.mas_equalTo(44);
    }];
    
    self.infoTV = [self addTVs];
    [self.infoTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(infoL.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
}

- (void)setDefaultValue {
    //self.defaultUrlTF.placeholder = RootURL_Server_SP_Debug;
    //self.defaultUrlTF.text        = [DomainConfig share].domainJCH;
}

#pragma mark - UITableView
- (UITableView *)addTVs {
    UITableView * oneTV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    oneTV.delegate   = self.present;
    oneTV.dataSource = self.present;
    
    oneTV.allowsMultipleSelectionDuringEditing = YES;
    oneTV.directionalLockEnabled = YES;
    
    oneTV.estimatedRowHeight           = 0;
    oneTV.estimatedSectionHeaderHeight = 0;
    oneTV.estimatedSectionFooterHeight = 0;
    
    //oneTV.separatorColor = ColorTV_separator;
    
    [self.view addSubview:oneTV];
    
    return oneTV;
}

- (void)keyboardFrameChanged:(CGRect)rect duration:(CGFloat)duration show:(BOOL)show {
    if (show) {
        [UIView animateWithDuration:duration animations:^{
            [self.infoTV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-rect.size.height);
            }];
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            [self.infoTV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
        }];
    }
}

//float gap = 10;
//float width = (ScreenSize.width - gap*2 - 3)/3;
//self.ccSize = CGSizeMake(width, width*1.2);


- (UICollectionView *)addCV {
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //[layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //设置headerView的尺寸大小
    //layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 20);
    //该方法也可以设置itemSize
    //layout.itemSize =CGSizeMake(110, 150);
    
    //2.初始化collectionView
    UICollectionView * cv = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    //cv.backgroundColor = ColorTV_DefaultBG;
    cv.layer.cornerRadius = 6;
    
    
    [self.view addSubview:cv];
    cv.backgroundColor = [UIColor whiteColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [cv registerClass:[PoporDomainConfigCC class] forCellWithReuseIdentifier:PoporDomainConfigCCKey];
    
    //4.设置代理
    cv.delegate   = self.present;
    cv.dataSource = self.present;
    
    int top = [self.navigationController getTopMargin];
    
    [cv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PoporDomainConfigVCXGap);
        make.top.mas_equalTo(top+10);
        
        make.right.mas_equalTo(-PoporDomainConfigVCXGap);
        
        PoporDomainConfig * pdConfig = [PoporDomainConfig share];
        if (pdConfig.netArray.count <= 1) {
            make.height.mas_equalTo(0);
        }else{
            make.height.mas_equalTo(PoporDomainConfigCCHeight);
        }
    }];
    
    return cv;
}

@end
