//
//  HomeLeftViewCellTableViewCell.m
//  ChildrenTemp
//
//  Created by qj on 15/3/23.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "HomeLeftViewCellTableViewCell.h"
@interface HomeLeftViewCellTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *spliteLine;
@end
@implementation HomeLeftViewCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_spliteLine setBackgroundColor:[UIColor blackColor]];
    [_spliteLine setAlpha:0.1];
    [_customeTitle setTextColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
