//
//  HostDBModel.h
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/10.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HostDBModel : HostBaseModel
@property(nonatomic, assign) NSInteger ID;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *url;
@end

NS_ASSUME_NONNULL_END
