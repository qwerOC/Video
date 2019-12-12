//
//  HostsTools.m
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/11.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostsTools.h"
#import <AVKit/AVKit.h>
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
+ (NSString*)getVideoTimeByUrlString:(NSString*)urlString{

    NSURL* url = [NSURL URLWithString:urlString];
    AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL:url];
    CMTime durationV =   songItem.asset.duration;
    NSUInteger dTotalSeconds = CMTimeGetSeconds(durationV);
    NSUInteger dHours = floor(dTotalSeconds / 3600);
    NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
    NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
    NSString *videoDurationText = [NSString stringWithFormat:@"%i:%02i:%02i",dHours, dMinutes, dSeconds];
    return  videoDurationText;
}

@end
