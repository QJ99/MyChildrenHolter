//
//  HomeLeftView.m
//  ChildrenTemp
//
//  Created by qj on 15/3/23.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "HomeLeftView.h"
#import "LeftTableModel.h"
#import "HomeLeftViewCellTableViewCell.h"
static NSString *CellReuseIdentifier = @"cell";
@interface HomeLeftView()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UIImageView *spliteTopLine;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *spliteBottonLine;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIImageView *temputerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *clothingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *environmentImageView;
@property (weak, nonatomic) IBOutlet UIView *tempBgView;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapTempBgView;
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
    model1.iconName = @"left_side_knowledge";
//    model1.modelDo = ^(){
//    };
    model1.pushName = @"KnowLedgeViewController";
    
    LeftTableModel *model2 = [[LeftTableModel alloc]init];
    model2.titleName = @"设置";
    model2.iconName = @"left_side_setting";
//    model2.modelDo = ^(){
//    };
    model2.pushName = @"SettingViewController";
    
    LeftTableModel *model3 = [[LeftTableModel alloc]init];
    model3.titleName = @"服药提醒";
    model3.iconName = @"left_side_remind";
    model3.pushName = @"RemindViewController";
//    model3.modelDo = ^(){
//    };
    _dataSource = [NSMutableArray arrayWithObjects:model1,model2,model3, nil];
    [_myTableView registerNib:[UINib nibWithNibName:@"HomeLeftViewCellTableViewCell" bundle:nil] forCellReuseIdentifier:CellReuseIdentifier];
    [self tapItemButton:_tapTempBgView];
}
#pragma mark -点击进入用户中心
- (IBAction)TapuserCentry:(UITapGestureRecognizer *)sender {
    if ([_delegate respondsToSelector:@selector(homeLeftView:selectItem:)]) {
        [_delegate homeLeftView:self selectItem:@"UserCentryViewController"];
    }
}
#pragma mark -点击分类模块
- (IBAction)tapItemButton:(UITapGestureRecognizer *)sender {
    if (sender.view.tag == 1) {//体温测量
        UIImage *imageN = [UIImage imageNamed:@"temp_unselected"];
        UIImage *imageS = [UIImage imageNamed:@"temp_selected"];
        if ([_temputerImageView.image isEqual:imageN] ) {
            [_temputerImageView setImage:imageS];
            [_clothingImageView setImage:[UIImage imageNamed:@"climate_unselected"]];
            [_environmentImageView setImage:[UIImage imageNamed:@"huanjing_unselected"]];
            [self tellDelegateSelectItem:@"体温测量"];
        }
    }else if (sender.view.tag == 2){//衣内微气候
        UIImage *imageN = [UIImage imageNamed:@"climate_unselected"];
        UIImage *imageS = [UIImage imageNamed:@"climate_selected"];
        if ([_clothingImageView.image isEqual:imageN]) {
            [_clothingImageView setImage:imageS];
            [_temputerImageView setImage:[UIImage imageNamed:@"temp_unselected"]];
            [_environmentImageView setImage:[UIImage imageNamed:@"huanjing_unselected"]];
            [self tellDelegateSelectItem:@"衣内微气候"];
        }
    }else if (sender.view.tag == 3){//环境温湿度
        UIImage *imageN = [UIImage imageNamed:@"huanjing_unselected"];
        UIImage *imageS = [UIImage imageNamed:@"huanjing_selected"];
        if ([_environmentImageView.image isEqual:imageN]) {
            [_environmentImageView setImage:imageS];
            [_clothingImageView setImage:[UIImage imageNamed:@"climate_unselected"]];
            [_temputerImageView setImage:[UIImage imageNamed:@"temp_unselected"]];
            [self tellDelegateSelectItem:@"环境温湿度"];
        }
    }
}
#pragma mark -通知代理
-(void)tellDelegateSelectItem:(NSString*)selectItem{
    if ([_delegate respondsToSelector:@selector(homeLeftView:selectItem:)]) {
        [_delegate homeLeftView:self selectItem:selectItem];
    }
}
#pragma mark -tableviewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeLeftViewCellTableViewCell *cell = [_myTableView dequeueReusableCellWithIdentifier:CellReuseIdentifier];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LeftTableModel *model = _dataSource[indexPath.row];
    cell.customeTitle.text = model.titleName;
    cell.iconImageView.image = [UIImage imageNamed:model.iconName];
    return cell;
    
}
#pragma mark -tableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftTableModel *model = _dataSource[indexPath.row];
    if ([_delegate respondsToSelector:@selector(homeLeftView:selectItem:)]) {
        [_delegate homeLeftView:self selectItem:model.pushName];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
