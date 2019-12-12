//
//  HostConsultingDetailViewController.m
//  ShopshopHosts
//
//  Created by 苏秋东 on 2019/2/20.
//  Copyright © 2019 刘坤. All rights reserved.
//

#import "NGConsultingDetailViewController.h"
#import "PlayViewController.h"
#import <WebKit/WebKit.h>
#import "HWNavViewController.h"
#import "PlayViewController.h"
#import "HostplayViewController.h"
@interface NGConsultingDetailViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) UIButton *button;
@property(nonatomic, strong) NSString *currtentUrl;
@end

@implementation NGConsultingDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.view.frame.size.height>=812) {
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
        }
    }
    self.view.backgroundColor=[UIColor whiteColor];
    self.progressView=[[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, MuScreen_Width, 2)];
    self.progressView.backgroundColor=[UIColor whiteColor];
    self.progressView.progressTintColor=[UIColor blackColor];
    self.progressView.trackTintColor=[UIColor whiteColor];
    [self.progressView setProgress:0 animated:NO];
    [self.view addSubview:self.progressView];
    NSString * urlStr = [_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString: _url];
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
    preference.javaScriptCanOpenWindowsAutomatically = NO;
    WKWebViewConfiguration *config                =[[WKWebViewConfiguration alloc] init];
    config.preferences                               = preference;
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback                 = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    config.requiresUserActionForMediaPlayback        = YES;
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback       = NO;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    config.applicationNameForUserAgent               = @"1111";
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,2, self.view.frame.size.width, MuScreen_Height-SafeAreaTopHeight-2)
                                  configuration:config];
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    _webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
    
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    //添加监测网页加载进度的观察者
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:0
                      context:nil];
    //添加监测网页标题title的观察者
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    //监听UIWindow显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];
    //监听UIWindow隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    
    self.button=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.button setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(clickVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-140);
    }];
}
-(void)clickVideo{
    HWNavViewController *video=[[HWNavViewController alloc] init];
    video.htmlStr=self.currtentUrl;
    __weak typeof(self) weakSelf = self;
    video.getUrl = ^(NSString * _Nonnull urlStr, NSString * _Nonnull htmlUrl) {
        dispatch_async(dispatch_get_main_queue(), ^{
        HostplayViewController *play=[[HostplayViewController alloc] init];
          play.url=urlStr;
            [weakSelf presentViewController:play animated:YES completion:nil];
        });
      
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
//kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _webView) {
        NSLog(@"网页加载进度 = %f",_webView.estimatedProgress);
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    }else if([keyPath isEqualToString:@"title"]
             && object == _webView){
        self.navigationItem.title = _webView.title;
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

-(void)returnClick{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//    self.currtentUrl=[NSString stringWithFormat:@"%@",webView.URL.absoluteString];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.currtentUrl=[NSString stringWithFormat:@"%@",webView.URL.absoluteString];
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    self.currtentUrl=[NSString stringWithFormat:@"%@",webView.URL.absoluteString];
    if ([webView.URL.absoluteString containsString:@"play"]||
        [webView.URL.absoluteString containsString:@"cover"]||
        [webView.URL.absoluteString containsString:@"v_"]||
        [webView.URL.absoluteString containsString:@"alipay_video"]) {
        
        
        
    }
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
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"https://www.iqiyi.com/app/register_business/index"]) { // 对应的scheme
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow+2);
}
-(void)dealloc{
    //移除观察者
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(title))];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
