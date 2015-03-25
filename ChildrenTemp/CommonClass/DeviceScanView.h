//
//  DeviceScanView.h
//  ChildrenTemp
//
//  Created by QJ on 15/3/25.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceScanView : UIView
+(DeviceScanView*)loadDeviceScan;
-(void)refreshDataSource:(NSArray*)deviceArrayM;
@end
