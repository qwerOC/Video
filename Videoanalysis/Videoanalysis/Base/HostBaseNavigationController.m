//
//  HostBaseNavigationController.m
//  ShopshopHosts
//
//  Created by 苏秋东 on 2018/12/12.
//  Copyright © 2018 苏秋东. All rights reserved.
//

#import "HostBaseNavigationController.h"
#import "HostBaseViewController.h"
@interface HostBaseNavigationController ()
<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation HostBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barStyle = UIBarStyleDefault;
    self.interactivePopGestureRecognizer.enabled = NO;
    __weak HostBaseNavigationController *weakSelf = self;
    self.navigationController.view.backgroundColor=[UIColor whiteColor];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
  if (@available(iOS 13.0, *)) {
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
    } else {
        // Fallback on earlier versions
    }
}
- (void)setPrefersLargeTitlesBool:(BOOL)prefersLargeTitlesBool{
    _prefersLargeTitlesBool = prefersLargeTitlesBool;
    //    ios11新特性
    if (@available(iOS 11.0, *)) {
        self.navigationBar.prefersLargeTitles = _prefersLargeTitlesBool;
        if (_prefersLargeTitlesBool) {
            self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
            [self.navigationBar setLargeTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:34.0f],NSFontAttributeName,nil]];
        }else{
            self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
        }
        
        [UIScrollView appearance].contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
	
}


//重写push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        if ([viewController isKindOfClass:[HostBaseViewController class]]) {
            HostBaseViewController *baseCtr = (HostBaseViewController *)viewController;
            if ([baseCtr respondsToSelector:@selector(leftMenuBarButtonItem)]) {
                baseCtr.navigationItem.leftBarButtonItem = [baseCtr leftMenuBarButtonItem];
            }
        }
    }
    //处理左滑手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    // Enable the gesture again once the new controller is shown
    if ([viewController isKindOfClass:[HostBaseViewController class]]) {
        HostBaseViewController *baseCtr = (HostBaseViewController *)viewController;
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && baseCtr.popGestureEnable == YES){

            self.interactivePopGestureRecognizer.enabled = YES;
        }else{
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }else{
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
 
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    if (self.childViewControllers.count > 1) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
    return YES;
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    //只有一个控制器的时候禁止手势，防止卡死现象
    if (self.childViewControllers.count == 1) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

@end
