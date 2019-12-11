//
//  HostsTools.m
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/11.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostsTools.h"

@implementation HostsTools
+ (BOOL)isBlankString:(NSString *)string{
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}
@end
