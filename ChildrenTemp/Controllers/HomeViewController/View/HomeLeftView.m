//
//  HomeLeftView.m
//  ChildrenTemp
//
//  Created by qj on 15/3/23.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "HomeLeftView.h"
#import "CustomeButton.h"
#import "LeftTableModel.h"
#import "HomeLeftViewCellTableViewCell.h"
static NSString *CellReuseIdentifier = @"cell";
@interface HomeLeftView()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UIImageView *spliteTopLine;
@property (weak, nonatomic) IBOutlet CustomeButton *temputerButton;
@property (weak, nonatomic) IBOutlet CustomeButton *clothClimate;
@property (weak, nonatomic) IBOutlet CustomeButton *environment;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *spliteBottonLine;
@property (strong, nonatomic) NSMutableArray *dataSource;
@end
@implementation HomeLeftView
+(HomeLeftView *)loadHomeLeftView{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"HomeLeftView" owner:self options:nil];
    return [nib objectAtIndex:0];
}
-(void)awakeFromNib{
    [self setBackgroundColor:kcolorWithRGB(136, 101, 93)];
    [_spliteTopLine setBackgroundColor:[UIColor blackColor]];
    [_spliteTopLine setAlpha:0.1];
    [_spliteBottonLine setBackgroundColor:[UIColor blackColor]];
    [_spliteBottonLine setAlpha:0.1];
    [_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _myTableView.showsVerticalScrollIndicator = NO;
    [_myTableView setBackgroundColor:[UIColor clearColor]];
    _myTableView.scrollEnabled = NO;
    
    [_loginButton setBackgroundColor:kcolorWithRGB(253, 109, 68)];
    _loginButton.layer.cornerRadius = 20;
    _loginButton.layer.masksToBounds = YES;
    [_loginButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    LeftTableModel *model1 = [[LeftTableModel alloc]init];
    model1.titleName = @"知识";
    model1.iconName = @"";
    model1.modelDo = ^(){
    };
    
    LeftTableModel *model2 = [[LeftTableModel alloc]init];
    model2.titleName = @"设置";
    model2.iconName = @"";
    model2.modelDo = ^(){
    };
    
    LeftTableModel *model3 = [[LeftTableModel alloc]init];
    model3.titleName = @"服药提醒";
    model3.iconName = @"";
    model3.modelDo = ^(){
    };
    _dataSource = [NSMutableArray arrayWithObjects:model1,model2,model3, nil];
    [_myTableView registerNib:[UINib nibWithNibName:@"HomeLeftViewCellTableViewCell" bundle:nil] forCellReuseIdentifier:CellReuseIdentifier];
}
#pragma mark -点击分类模块
- (IBAction)tapItemButton:(UITapGestureRecognizer *)sender {
    MyLog(@"----%d",sender.view.tag);
}

#pragma mark -tableviewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_myTableView dequeueReusableCellWithIdentifier:CellReuseIdentifier];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LeftTableModel *model = _dataSource[indexPath.row];
    cell.textLabel.text = model.titleName;
    return cell;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
