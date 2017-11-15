//
//  DeviceStyleView.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DeviceStyleView.h"
#import "DeviceFontStyleCell.h"
#import "DeviceFontSizeCell.h"

@implementation DeviceStyleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createNavWithTitle:@"名牌风格" createMenuItem:^UIView *(int nIndex){
            if (nIndex == 0){
                UIButton *btn = NewBackButton(nil);
                [btn setTitle:@"关闭" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:17];
                [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
                self.backButton = btn;
                return btn;
            }
            else if (nIndex == 1){
                UIButton *btn = NewTextButton(@"保存", [UIColor whiteColor]);
                [btn setFrame:CGRectMake(self.baseView.width - 64, 0, 54, 44)];
                [btn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
                self.saveButton = btn;
                return btn;
            }
            
            return nil;
        }];
        [self.baseView addSubview:self.tableView];
    }
    return self;
}

- (void)saveButtonAction {
    [[UserPublic getInstance] updateMeetingRoomFontStyle];
    [self dismiss];
}

#pragma getter
- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, self.baseView.width, self.baseView.height - STATUS_BAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.separatorColor = baseSeparatorColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |  UIViewAutoresizingFlexibleBottomMargin;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    
    return _tableView;
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [UserPublic getInstance].fontArray.count;
    }
    else if (section == 1) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 57;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 64;
    }
    else if (indexPath.section == 1) {
        
    }
    return kCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 57)];
    bgView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(kEdge, 21, bgView.width - 2 * kEdge, 21)];
    titleLable1.numberOfLines = 0;
    titleLable1.font = [UIFont systemFontOfSize:16];
    titleLable1.textColor = [UIColor whiteColor];
    [bgView addSubview:titleLable1];
    if (section == 0) {
        titleLable1.text = @"字体样式";
    }
    else if (section == 1) {
        titleLable1.text = @"字体大小";
    }
    
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"style_cell";
        DeviceFontStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[DeviceFontStyleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *m_dic = [UserPublic getInstance].fontArray[indexPath.row];
        cell.title = m_dic[@"showName"];
        cell.like = [UserPublic getInstance].selectedRoomInfo.style_info.index % [UserPublic getInstance].fontArray.count == indexPath.row;
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"size_cell";
        DeviceFontSizeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[DeviceFontSizeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        [UserPublic getInstance].selectedRoomInfo.style_info.index = indexPath.row;
        [tableView reloadData];
    }
    else if (indexPath.section == 1) {
        
    }
}

@end
