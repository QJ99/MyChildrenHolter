//
//  DeviceScanView.h
//  ChildrenTemp
//
//  Created by QJ on 15/3/25.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceScanView;
@protocol deviceDelegate<NSObject>
-(void)deviceScanview:(DeviceScanView*)scanview didSelectIndex:(NSInteger)index;
-(void)deviceScanview:(DeviceScanView *)scanview didSelectCancle:(BOOL)cancle;
@end
@interface DeviceScanView : UIView
@property(weak, nonatomic) id<deviceDelegate>delegate;
+(DeviceScanView*)loadDeviceScan;
-(void)refreshDataSource:(NSArray*)deviceArrayM;
@end
