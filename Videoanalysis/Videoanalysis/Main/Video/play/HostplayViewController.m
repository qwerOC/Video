//
//  HostplayViewController.m
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/12.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostplayViewController.h"
#import <SuperPlayer/SuperPlayer.h>
@interface HostplayViewController ()<SuperPlayerDelegate>
@property(nonatomic, strong) SuperPlayerView *playerView;
@end

@implementation HostplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _playerView = [[SuperPlayerView alloc] init];
    // 设置代理，用于接受事件
    _playerView.delegate = self;
    // 设置父 View，_playerView 会被自动添加到 holderView 下面
    _playerView.fatherView = self.view;

    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    // 设置播放地址，直播、点播都可以
    playerModel.videoURL = self.url;
    // 开始播放
    [_playerView playWithModel:playerModel];
//    [SuperPlayerWindow sharedInstance].superPlayer = _playerView; // 设置小窗显示的播放器
//    [SuperPlayerWindow sharedInstance].backController = self;  // 设置返回的view controller
//    [[SuperPlayerWindow sharedInstance] show]; // 悬浮显示
}
- (void)superPlayerBackAction:(SuperPlayerView *)player{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    [_playerView resetPlayer];
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
