//
//  CalendarSelectView.m
//  ChildrenTemp
//
//  Created by QJ on 15/3/26.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "CalendarSelectView.h"
#import "CalendarTableViewCell.h"
@interface CalendarSelectView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *showDateTime;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@end
@implementation CalendarSelectView
-(void)awakeFromNib{
    _connectButton.layer.cornerRadius = 5.0f;
    _connectButton.layer.masksToBounds = YES;
    UITableView *myTabelView =  [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50) style:UITableViewStylePlain];
    [myTabelView setDelegate:self];
    [myTabelView setDataSource:self];
    [myTabelView setBackgroundView:nil];
    [myTabelView setBackgroundColor:[UIColor clearColor]];
    [myTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    myTabelView.transform = CGAffineTransformMakeRotation(M_PI/2*3);
    [self addSubview:myTabelView];
    myTabelView.frame = CGRectMake(0, 0,self.frame.size.width, 50);
    myTabelView.showsHorizontalScrollIndicator = NO;
    myTabelView.showsVerticalScrollIndicator = NO;
   
}
#pragma mark tableviewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    CalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CalendarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.calendarDayText.textColor = [UIColor blackColor];
    cell.calendarDayText.text = @"呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵";
    return cell;
}
#pragma mark tableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
      return 50;
}
- (IBAction)connectButtonClick:(UIButton *)sender {
}
+(CalendarSelectView *)loadCalendara{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CalendarSelectView" owner:self options:nil];
    return [nib firstObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
