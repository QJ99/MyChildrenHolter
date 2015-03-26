//
//  DeviceScanView.m
//  ChildrenTemp
//
//  Created by QJ on 15/3/25.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "DeviceScanView.h"
#import "DeviceScanViewTableViewCell.h"
static NSString *ReuseIdentifier = @"cell";
@interface DeviceScanView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger selectIndex;
@end
@implementation DeviceScanView

-(void)awakeFromNib{
    _dataSource = [NSMutableArray array];
    [_dataSource addObjectsFromArray:@[@"hehe",@"haha",@"hiahia"]];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    _myTableView.showsVerticalScrollIndicator = NO;
    [_myTableView registerNib:[UINib nibWithNibName:@"DeviceScanViewTableViewCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    [_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
     _selectIndex = 0;

}
-(void)refreshDataSource:(NSArray *)deviceArrayM{
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:deviceArrayM];
    if ([_dataSource count]==1) {
        _myTableView.scrollEnabled = NO;
    }else{
        _myTableView.scrollEnabled = YES;
    }
    [_myTableView reloadData];
}
#pragma mark -tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceScanViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    NSString *peripheralName = _dataSource[indexPath.row][hName];
    cell.showTextLb.text = peripheralName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == _selectIndex){
        [cell resetStatus:YES];
    }else{
         [cell resetStatus:NO];
    }
    return cell;
}
#pragma mark -tableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_selectIndex != -1) {
        DeviceScanViewTableViewCell *cell = (DeviceScanViewTableViewCell *)[_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
        [cell resetStatus:NO];
    }
    
    _selectIndex = indexPath.row;
    DeviceScanViewTableViewCell *cell = (DeviceScanViewTableViewCell *)[_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
    [cell resetStatus:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
+(DeviceScanView *)loadDeviceScan{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DeviceScanView" owner:self options:nil];
    return [nib firstObject];
}
- (IBAction)buttonClick:(UIButton *)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"取消"]) {
        if ([_delegate respondsToSelector:@selector(deviceScanview:didSelectIndex:)]) {
            [_delegate deviceScanview:self didSelectCancle:YES];
        }
    }else if([[sender titleForState:UIControlStateNormal]isEqualToString:@"确定"]){
        if ([_delegate respondsToSelector:@selector(deviceScanview:didSelectIndex:)]) {
            [_delegate deviceScanview:self didSelectIndex:_selectIndex];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
