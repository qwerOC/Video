//
//  HostPopVC.h
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/6.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HostPopVC : HostBaseViewController
@property(nonatomic, strong) NSString *htmlUrl;
@property(nonatomic, strong) HostBaseNavigationController *nav;
@property(nonatomic, copy) void (^getUrl)(NSString *urlStr,NSString *htmlUrl);
@end

NS_ASSUME_NONNULL_END
