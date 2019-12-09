//
//  PlayViewController.m
//  LiveSw
//
//  Created by lvqiang on 2019/11/23.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "PlayViewController.h"
#import <WebKit/WebKit.h>
#import "HWNavViewController.h"
@interface PlayViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.view.frame.size.height>=812) {
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
        }
    }
    self.view.backgroundColor=[UIColor whiteColor];
    self.progressView=[[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    self.progressView.backgroundColor=[UIColor whiteColor];
    self.progressView.progressTintColor=[UIColor blackColor];
    self.progressView.trackTintColor=[UIColor whiteColor];
    [self.progressView setProgress:0 animated:NO];
    [self.view addSubview:self.progressView];
    
    NSString * urlStr = [_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://660e.com/?url=%@",_url]];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:urlStr]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:30];
    //    [self.webView loadRequest:request];
    // 创建设置对象
    WKPreferences *preference                        = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    // 会影响页面加载
    //         preference.minimumFontSize                     = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled                     = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    WKWebViewConfiguration *config                =[[WKWebViewConfiguration alloc] init];
    config.preferences                               = preference;
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback                 = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    config.requiresUserActionForMediaPlayback        = NO;
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback       = NO;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    config.applicationNameForUserAgent               = @"1111";
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, MuScreen_Height-SafeAreaTopHeight)
                                  configuration:config];
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    _webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:_webView];
    [_webView loadRequest:request];
    
    //监听UIWindow显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];
    //监听UIWindow隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    [self creatRightBtnOfCustomWithTitle:@"切换线路"];
}

-(void)rigthBtnClcik{
    HWNavViewController *video=[[HWNavViewController alloc] init];
    video.htmlStr=self.htmlUrl;
    __weak typeof(self) weakSelf = self;
    video.getUrl = ^(NSString * _Nonnull urlStr, NSString * _Nonnull htmlUrl) {
        NSString * urlS = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@", urlS]];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                  timeoutInterval:30];
        [weakSelf.webView loadRequest:request];
    };
    [self presentPanModal:video];
}
#pragma mark --全屏监听
-(void)beginFullScreen{
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationNone];
}
-(void)endFullScreen{
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationNone];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}
//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}
// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
