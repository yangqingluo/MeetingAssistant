//
//  DeviceStyleView.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SideBarView.h"

@interface DeviceStyleView : SideBarView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
