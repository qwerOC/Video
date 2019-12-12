//
//  HostRequestManager.m
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/12.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostRequestManager.h"
static HostRequestManager *requestCache=nil;
@implementation HostRequestManager

+(instancetype)shareRequestManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//    requestCache=[[super alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[MuUserDefaults objectForKey:@"InterNetWork"]]]];
        requestCache=[[super alloc] initPrivate];
    });
    return requestCache;
}
-(id)copyWithZone:(NSZone *)zone
{
    return requestCache;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return requestCache;
}
-(instancetype)initPrivate{
    if (self=[super init]) {
        self.sessionManager = [AFHTTPSessionManager manager];
        AFJSONResponseSerializer *jsonSerial=[AFJSONResponseSerializer serializer];
        jsonSerial.removesKeysWithNullValues=YES;
        self.sessionManager.responseSerializer =  jsonSerial;
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        //设置请求超时
        [self.sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.sessionManager.requestSerializer.timeoutInterval = 20.f;
        [self.sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [self.sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil]];
    }
    return self;
}
-(void)getRequest:(NSString*)url
       withParams:(NSDictionary*)params
          success:(void (^)(id obj))success
          failure:(void (^)(NSError *error))failure{
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
     [self.sessionManager.requestSerializer setValue:@"charset=UTF-8"forHTTPHeaderField:@"Content-Type"];
    [self.sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil]];
//    转义所有的连接
    [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"======%@",url);
    [[HostRequestManager shareRequestManager].sessionManager
     GET:urlStr
     parameters:params
     progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *nameStr =  [[NSString alloc]initWithData: responseObject encoding:NSUTF8StringEncoding];
          NSLog(@"======%@",nameStr);
        success(nameStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"=====%@",error.description);
        failure(error);
    }];
}

@end
  
