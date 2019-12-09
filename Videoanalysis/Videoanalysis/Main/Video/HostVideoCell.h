//
//  HostVideoCell.h
//  Videoanalysis
//
//  Created by lvqiang on 2019/11/29.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HostVideoCell : HostTableViewCell
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@end

NS_ASSUME_NONNULL_END
