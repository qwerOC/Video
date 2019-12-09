//
//  HostPopVC.m
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/6.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostPopVC.h"
#import "PlayViewController.h"

@interface HostPopVC ()<UITableViewDelegate,UITableViewDataSource,HWPanModalPresentable>

@property(nonatomic, strong) UITableView *analysisTale;
@end

@implementation HostPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self jsonAnalysis];
    [self loadUI];
}
-(void)jsonAnalysis{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"analysis" ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    self.dataArray=[[NSMutableArray  alloc] initWithArray:dic[@"data"]];
}
-(void)loadUI{
     self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title=@"视频解析地址";
    _analysisTale = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  MuScreen_Width,
                                                                  MuScreen_Height-SafeAreaBottomHeight-SafeAreaTopHeight-NGTabBarHeight+StatusBarHeight)
                                                 style:UITableViewStylePlain];
    _analysisTale.dataSource=self;
    _analysisTale.delegate=self;
    [self.view addSubview:_analysisTale];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellInderfiner=@"cellInderfiner";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellInderfiner];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellInderfiner];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=[NSString stringWithFormat:@"%@%ld",self.dataArray[indexPath.row][@"name"],indexPath.row+1];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"url"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    PlayViewController *play=[[PlayViewController alloc] init];
//    play.url=[NSString stringWithFormat:@"%@%@",self.dataArray[indexPath.row][@"url"],self.htmlUrl];
    if (self.getUrl) {
        self.getUrl([NSString stringWithFormat:@"%@%@",self.dataArray[indexPath.row][@"url"],self.htmlUrl],self.htmlUrl);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController pushViewController:play animated:YES];
}
#pragma mark - HWPanModalPresentable

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMax, 100);
}

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 200);
}

- (UIScrollView *)panScrollable {
    return self.analysisTale;
}

- (BOOL)anchorModalToLongForm {
    return YES;
}

@end
