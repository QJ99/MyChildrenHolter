//
//  HomeLeftView.h
//  ChildrenTemp
//
//  Created by qj on 15/3/23.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeLeftView;
@protocol homeLeftDelegate<NSObject>
-(void)homeLeftView:(HomeLeftView*)leftView selectItem:(NSString*)selelctItem;
@end
@interface HomeLeftView : UIView
@property (weak, nonatomic) id<homeLeftDelegate>delegate;
+(HomeLeftView*)loadHomeLeftView;
@end
