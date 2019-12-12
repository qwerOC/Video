//
//  HostRequestManager.h
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/12.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HostRequestManager : NSObject
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

+(instancetype)shareRequestManager;
/// get请求
/// @param url 请求地址+路径
/// @param params 请求参数
/// @param success 成功回调
/// @param failure 失败毁掉
-(void)getRequest:(NSString*)url
       withParams:(NSDictionary*)params
          success:(void (^)(id obj))success
          failure:(void (^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
