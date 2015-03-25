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
//    CBPeripheral *peripheral = _dataSource[indexPath.row][hDevice];
    
    NSString *peripheralName = _dataSource[indexPath.row][hName];
    cell.showTextLb.text = peripheralName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark -tableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
+(DeviceScanView *)loadDeviceScan{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DeviceScanView" owner:self options:nil];
    return [nib firstObject];
}
- (IBAction)buttonClick:(UIButton *)sender {
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
