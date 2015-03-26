//
//  DeviceScanViewTableViewCell.h
//  ChildrenTemp
//
//  Created by QJ on 15/3/25.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DeviceScanViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *showTextLb;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
- (void)resetStatus:(BOOL)normal;
@end
