//
//  DeviceScanViewTableViewCell.m
//  ChildrenTemp
//
//  Created by QJ on 15/3/25.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "DeviceScanViewTableViewCell.h"
@interface DeviceScanViewTableViewCell()

@end
@implementation DeviceScanViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _statusImageView.layer.cornerRadius = _statusImageView.frame.size.width *0.5;
    _statusImageView.layer.masksToBounds = YES;
    [_statusImageView setBackgroundColor:[UIColor clearColor]];
    [_statusImageView setContentMode:UIViewContentModeScaleAspectFit];
}
- (void)resetStatus:(BOOL)normal{
    [_statusImageView setImage:[UIImage imageNamed:(normal ? @"DeviceScanHover" : @"DeviceScanNormal")]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
