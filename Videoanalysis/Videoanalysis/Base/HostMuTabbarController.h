//
//  HostMuTabbarController.h
//  ShopshopHosts
//
//  Created by 刘坤 on 2018/1/4.
//  Copyright © 2018年 刘坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostMuTabbarController : UITabBarController
@property (nonatomic,assign) NSInteger  indexFlag;//记录上一次点击tabbar，使用时，记得先在init或viewDidLoad里 初始化 = 0
- (void)setUpAllChildVc;

@end
