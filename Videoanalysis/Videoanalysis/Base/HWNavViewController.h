//
//  HWNavViewController.h
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWNavViewController : HostBaseNavigationController
@property(nonatomic, strong) NSString *htmlStr;
@property(nonatomic, copy) void (^getUrl)(NSString *urlStr,NSString *htmlUrl);

@end

NS_ASSUME_NONNULL_END
