//
//  HostBaseViewController.m
//  ShopshopHosts
//
//  Created by 苏秋东 on 2018/12/12.
//  Copyright © 2018 苏秋东. All rights reserved.
//

#import "HostBaseViewController.h"
#import "AppDelegate.h"
@interface HostBaseViewController ()

@end

@implementation HostBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popGestureEnable = YES;
    self.view.backgroundColor =[UIColor whiteColor] ;
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBar.translucent = NO;
    self.page_num = 1;
    self.page_size = 20;
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (void)setPopGestureEnable:(BOOL)popGestureEnable{
    if (!popGestureEnable) {
        id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
        [self.view addGestureRecognizer:pan];
    }
}

- (void)gotoHomeVC{
    self.popGestureEnable = YES;
    self.navigationController.navigationBarHidden=NO;
    
    HostMuTabbarController * tabbar = [[HostMuTabbarController alloc]init];
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.tabbarVC = tabbar;
    
    [UIApplication sharedApplication].delegate.window.rootViewController =tabbar;
}

//推送需要的--传递推送参数
- (void)pushNoticficationParameters:(NSDictionary*)parameters{
    
}


- (void)tapRefresh{
    if (self.clikEmptyView) {
        self.clikEmptyView();
    }
}



- (void)creatRightBtnOfUploadList{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"上传列表" style:UIBarButtonItemStylePlain target:self action:@selector(uploadList)];
}

- (void)uploadList{
    
}

- (void)creatRightBtnOfFinish{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishClick)];
}
- (void)finishClick{
    
}

- (void)creatRightBtnOfNext{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextClick)];
}

- (void)nextClick{
    
}

- (void)creatLeftBtnOfReturn{
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:MuGetImage(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
}
- (void)creatLeftBtnOfLoginReturn{
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"login_back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
}
- (void)returnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatLeftBtnOfCustomWithTitle:(NSString *)title{
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:title
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(leftBtnClcik)];
}
-(void)creatRightBtnOfCustomWithTitle:(NSString *)title{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:title
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(rigthBtnClcik)];

}
-(void)rigthBtnClcik{
    
}
- (void)leftBtnClcik{
    
}
-(UIBarButtonItem*)leftMenuBarButtonItem{
    
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                            style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(returnClick)];
}

-(void)creatRightBtnOfCustomWithImage:(NSString *)imageName
{
  self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                            style:UIBarButtonItemStylePlain
                                           target:self
                                            action:@selector(rigthBtnClcik)];
}
- (void)rightBtnClcik{
    
}


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be needed later.
            // 加一些代码保存可能会需要用到的数据。
            // Add code to clean up other strong references to the view in the view hierarchy.
            //清理view里所有的强引用对象。
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}
- (void)       showNoDataViewToView:(UIView*)superview withString:(NSString*)string{
    UIView *emptyView=[superview viewWithTag:456789];
    if (emptyView) {
        [emptyView removeFromSuperview];
    }
    
    UIView *createView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(superview.frame), CGRectGetHeight(superview.frame))];
    createView.tag=456789;
    [superview addSubview:createView];
    [superview bringSubviewToFront:createView];
    UILabel *tipLab=[[UILabel alloc] initWithFrame:CGRectZero];
    tipLab.text=string;
    tipLab.textColor=[UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1];
    tipLab.textAlignment=NSTextAlignmentCenter;
    tipLab.font=[UIFont systemFontOfSize:24];
    [createView addSubview:tipLab];
    UIButton *tipBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [tipBtn addTarget:self action:@selector(clickTipBtn) forControlEvents:UIControlEventTouchUpInside];
    [tipBtn setTitle:@"点击添加" forState:UIControlStateNormal];
    [tipBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [createView addSubview:tipBtn];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(createView);
    }];
    [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLab.mas_bottom).offset(5);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(30);
    }];
}
-(void)clickTipBtn{
    if (self.clikEmptyView) {
        self.clikEmptyView();
    }
}



-(void)hideNoDataViewFromView:(UIView *)superview{
    UIView *emptyView=[superview viewWithTag:456789];
      if (emptyView) {
          [emptyView removeFromSuperview];
      }
}
- (NSMutableDictionary *)dataDict{
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)cellArray{
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}


-(void)dealloc{
    
}
@end
