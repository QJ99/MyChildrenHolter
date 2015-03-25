//
//  LeftTableModel.h
//  ChildrenTemp
//
//  Created by qj on 15/3/23.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "BaseModel.h"
typedef void (^modelTodo)();
@interface LeftTableModel : BaseModel
@property(strong, nonatomic) NSString *titleName;
@property(strong, nonatomic) NSString *iconName;
@property(strong, nonatomic) NSString *pushName;
@property(copy, nonatomic) modelTodo modelDo;
@end
