//
//  Common.h
//  ChildrenTemp
//
//  Created by QJ on 15/2/2.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#ifndef ChildrenTemp_Common_h
#define ChildrenTemp_Common_h
#import "HolterChildDataManager.h"
#import "ChildHTTPSessionManager.h"
#import "TMCache.h"
#import "HolterChildBLEDataManager.h"
#define HHM  ((ChildHTTPSessionManager*)[ChildHTTPSessionManager shareChildHTTPSessionManager])
#define HDM  ((HolterChildDataManager*)[HolterChildDataManager sharedHolterChildDataManagerInstance])
#define TMC  ((TMCache*)[TMCache sharedCache])
#define HBM ((HolterChildBLEDataManager *)[HolterChildBLEDataManager sharedInstance])
/**
 *  Data Http Request
 */
#define HTTPDataAnalysisError @"数据错误"
#define HTTPConnectSeverError @"无网络，请连接网络"
#define HTTPConnectOutOfTime  @"网络异常，请求超时"
#define HTTPConnectFaildError @"网络异常，请求失败"

/**
 *  用户信息存储关键字
 */
#define kUserInfor @"kUserInfor"
//基类地址
#define kHttpRequestPath @"http://www.tmholter.com/baby/index.php/Interface/"
#define kcolorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
//日志输出宏定义
#define MyLog(...) NSLog(__VA_ARGS__)
#else
#define MyLog(...)
#endif
