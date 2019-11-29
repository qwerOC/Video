//
//  HostMuTabbarController.m
//  ShopshopHosts
//
//  Created by 刘坤 on 2018/1/4.
//  Copyright © 2018年 刘坤. All rights reserved.
//

#import "HostMuTabbarController.h"
#import "HostMineVC.h"
#import "HostVideoVC.h"
#import "HostBaseNavigationController.h"
@interface HostMuTabbarController ()

@end

@implementation HostMuTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置子视图
    self.indexFlag=0;
    [self setUpAllChildVc];
    
}
#pragma mark  ----three
-(void)threeclick:(NSNotification*)sender{
    switch ([sender.object longValue]) {
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        default:
            break;
    }
}


#pragma mark ---Tabbar子控制器
- (void)setUpAllChildVc {
    if (@available(iOS 13.0, *)) {
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
    } else {
        // Fallback on earlier versions
    }
    UIView *customBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabBar.bounds.origin.y, MuScreen_Width, self.tabBar.bounds.size.height+SafeAreaBottomHeight)];
    customBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:customBackgroundView atIndex:0];
    self.tabBar.translucent=NO;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, MuScreen_Width, 0.5)];
    view.backgroundColor = [UIColor colorWithRed:221/255.0 green:223/255.0 blue:228/255.0 alpha:0.9];
    [self.tabBar insertSubview:view atIndex:0];
    
    HostVideoVC *HomeVC = [[HostVideoVC alloc] init];
    [self setUpOneChildVcWithVc:HomeVC
                          Image:@"unselected1"
                  selectedImage:@"selected1"
                          title:NSLocalizedString(@"MuTabbarPublish", @"")];
    HostMineVC *cooperVC = [[HostMineVC alloc] init];
    [self setUpOneChildVcWithVc:cooperVC
                          Image:@"unselected2"
                  selectedImage:@"selected2"
                          title:NSLocalizedString(@"MuTabbarStore", @"")];
    
}
#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc
                        Image:(NSString *)image
                selectedImage:(NSString *)selectedImage
                        title:(NSString *)title
{
    HostBaseNavigationController *nav = [[HostBaseNavigationController alloc] initWithRootViewController:Vc];
    UIImage *colorImage = [UIImage jk_imageWithColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setShadowImage:colorImage];
    UIImage *myImage = [UIImage imageNamed:image];
    //myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    Vc.tabBarItem.title=title;
    //    选中颜色
    NSDictionary *selected = [NSDictionary dictionaryWithObject:[UIColor lightGrayColor]
                                                         forKey:NSForegroundColorAttributeName];
    [Vc.tabBarItem setTitleTextAttributes:selected forState:UIControlStateSelected];
    //    未选中颜色
    NSDictionary *unSelected = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                           forKey:NSForegroundColorAttributeName];
    [Vc.tabBarItem setTitleTextAttributes:unSelected forState:UIControlStateNormal];
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.selectedImage = mySelectedImage;
    if (@available(iOS 11.0, *)) {
        nav.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    } else {
    }
    [self addChildViewController:nav];
}
/// 点击tabbar 震动反馈

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator*impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
        [impactLight impactOccurred];
    } else {
        // Fallback on earlier versions
    }
    
}


@end
