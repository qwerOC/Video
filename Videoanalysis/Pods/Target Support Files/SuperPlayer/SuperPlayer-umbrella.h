#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UINavigationController+SuperPlayerRotation.h"
#import "UIViewController+SuperPlayerRotation.h"
#import "SPDefaultControlView.h"
#import "SPWeiboControlView.h"
#import "SuperPlayer.h"
#import "SuperPlayerControlView.h"
#import "SuperPlayerControlViewDelegate.h"
#import "SuperPlayerModel.h"
#import "SuperPlayerView.h"
#import "SuperPlayerViewConfig.h"
#import "SuperPlayerWindow.h"
#import "DataReport.h"
#import "J2Obj.h"
#import "NetWatcher.h"
#import "StrUtils.h"
#import "SuperEncrypt.h"
#import "TXCUrl.h"
#import "UIView+Fade.h"
#import "MMMaterialDesignSpinner.h"
#import "MoreContentView.h"
#import "PlayerSlider.h"
#import "SuperPlayerFastView.h"

FOUNDATION_EXPORT double SuperPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char SuperPlayerVersionString[];

