//
//  HostVideoCell.m
//  Videoanalysis
//
//  Created by lvqiang on 2019/11/29.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostVideoCell.h"

@implementation HostVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //    background-image: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.backgroundColor=[UIColor whiteColor];
    self.containView.layer.cornerRadius=10;
    self.containView.clipsToBounds = YES;
    self.containView.backgroundColor=[UIColor qmui_colorWithBackendColor:[UIColor qmui_colorWithHexString:@"667eea"]
                                                              frontColor:[UIColor qmui_colorWithHexString:@"764ba2"] ];
    self.icon.image=[UIImage imageNamed:@"video"];
    
    [self layoutIfNeeded];
    self.containView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containView.layer.shadowOffset = CGSizeMake(0,0);
    self.containView.layer.shadowOpacity = 0.3;
    self.containView.layer.shadowRadius = 3;
    self.containView.layer.masksToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        // 0.2 表示动画时长为0.2秒
        [UIView animateWithDuration:0.2 animations:^{
            // transform 使...变形
            // CGAffineTransformMakeScale(1.2, 1.2) 缩放的比例 缩放为原来的1.2倍
            self.transform = CGAffineTransformMakeScale(0.95, 0.95);
        } completion:^(BOOL finished) {
            // 完成后要将视图还原
            // CGAffineTransformIdentity
            
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            // transform 使...变形
            // CGAffineTransformMakeScale(1.2, 1.2) 缩放的比例 缩放为原来的1.2倍
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            // 完成后要将视图还原
            // CGAffineTransformIdentity
            [self.layer removeAllAnimations];
        }];
        
    }
}
@end
