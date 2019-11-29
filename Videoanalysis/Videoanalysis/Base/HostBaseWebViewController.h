//
//  HostBaseWebViewController.h
//  ShopshopHosts
//
//  Created by 苏秋东 on 2019/1/2.
//  Copyright © 2019 刘坤. All rights reserved.
//

#import "HostBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HostBaseWebViewController : HostBaseViewController



@property (nonatomic,copy) NSString *urlStr;

- (void)loadData;
@end

NS_ASSUME_NONNULL_END
