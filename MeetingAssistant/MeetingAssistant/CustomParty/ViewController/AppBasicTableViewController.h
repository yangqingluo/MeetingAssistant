//
//  AppBasicTableViewController.h
//  CRM2017
//
//  Created by yangqingluo on 2017/5/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicViewController.h"

@interface AppBasicTableViewController : AppBasicViewController<UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithStyle:(UITableViewStyle)style;

@property (nonatomic, strong) UITableView *tableView;


@end
