//
//  CalendarTableViewCell.m
//  ChildrenTemp
//
//  Created by QJ on 15/3/26.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "CalendarTableViewCell.h"

@implementation CalendarTableViewCell
- (void)awakeFromNib {
    // Initialization code
    [_calendarDayText setBackgroundColor:[UIColor clearColor]];
//    [_calendarDayText setTextColor:kUIColorFromRGB(0xa28f86)];
    [_calendarDayText setTextColor:[UIColor whiteColor]];
    [_calendarDayText setTextAlignment:NSTextAlignmentCenter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
