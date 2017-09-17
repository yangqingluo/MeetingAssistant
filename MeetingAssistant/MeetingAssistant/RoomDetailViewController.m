//
//  RoomDetailViewController.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/14.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "RoomDetailViewController.h"
#import "JXTAlertController.h"

#import "UICollectionView+Empty.h"
#import "DeviceCell.h"
#import "AddFriendView.h"
#import "CustomPopOverView.h"
#import "UIButton+ImageAndText.h"

static NSString *identify_DeviceCell = @"DeviceCell";

@interface RoomDetailViewController ()

@property (strong, nonatomic) AddFriendView *addFriedView;
@property (strong, nonatomic) CustomPopOverView *popItemsView;
@property (strong, nonatomic) NSMutableArray *deviceArray;

@end

@implementation RoomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self.collectionView registerClass:[DeviceCell class] forCellWithReuseIdentifier:identify_DeviceCell];
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)setupNav {
    [self createNavWithTitle:self.roomInfo.room_name createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"配置按钮"] forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(screen_width - 64, 0, 54, 44)];
            [btn addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editButtonAction:(UIButton *)button {
//    if (!_addFriedView) {
//        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"AddFriendView" owner:self options:nil] ;
//        _addFriedView = (AddFriendView *)[nib objectAtIndex:0];
//        _addFriedView.frame=CGRectMake(self.view.bounds.size.width-125, 0, 121, 138);
//        _addFriedView.hidden=YES;
//        [self.view addSubview:_addFriedView];
//    }
//    _addFriedView.hidden = !_addFriedView.hidden;
    [self.popItemsView showFrom:button alignStyle:CPAlignStyleRight];
}

-(IBAction)act:(UIButton *)sender
{
    if (sender.tag==0) {
        
    }
    else if (sender.tag==1)
    {
        
    }
    else{
        
    }
    
}

- (void)itemsButtonAction:(UIButton *)button {
    [self.popItemsView dismiss];
    switch (button.tag) {
        case 0:{
            NSArray *m_array = @[@{@"ip_address" : @"192.168.0.01", @"device_name" : @"张书记", @"summary" : @[@"image1", @"image2"], @"lighted" : @YES, @"state" : @0},
                                 @{@"ip_address" : @"192.168.0.05", @"device_name" : @"刘德全", @"lighted" : @NO, @"state" : @1},
                                 @{@"ip_address" : @"192.168.0.07", @"device_name" : @"李逵", @"lighted" : @NO, @"state" : @1},
                                 @{@"ip_address" : @"192.168.0.11", @"device_name" : @"刘爱丽", @"summary" : @[@"image1", @"image2"], @"lighted" : @YES, @"state" : @2},
                                 @{@"ip_address" : @"192.168.0.25", @"device_name" : @"王哲东", @"lighted" : @YES, @"state" : @2}];
            [self.deviceArray removeAllObjects];
            [self.deviceArray addObjectsFromArray:[APPDeviceInfo mj_objectArrayWithKeyValuesArray:m_array]];
            [self.collectionView reloadData];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - getter
- (CustomPopOverView *)popItemsView {
    if (!_popItemsView) {
        UIView *_itemsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400 * screen_width / 1024, 200)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _itemsView.width, 50)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = RGBA(0x6e, 0x6e, 0x6e, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.text = @"设置";
        [_itemsView addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom - 1.0, _itemsView.width, 1.0)];
        lineView.backgroundColor = baseSeparatorColor;
        [_itemsView addSubview:lineView];
        
        NSArray *itemsArray = @[@{@"name": @"发现设备", @"icon": @"发现设备按钮"},
                                @{@"name": @"会议纪要设置", @"icon": @"会议纪要设置"},
                                @{@"name": @"名牌风格设置", @"icon": @"名牌风格设置"},
                                ];
        NSUInteger itemsCount = itemsArray.count;
        CGFloat btnWidth = _itemsView.width / itemsCount;
        CGFloat btnHeight = _itemsView.height - titleLabel.bottom;
        for (NSUInteger i = 0; i < itemsCount; i++) {
            NSDictionary *m_dic = itemsArray[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(i * btnWidth, titleLabel.bottom, btnWidth, btnHeight)];
            [button setImage:[UIImage imageNamed:m_dic[@"icon"]] forState:UIControlStateNormal];
            [button setTitle:m_dic[@"name"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button verticalImageAndTitle:kEdge];
            [button addTarget:self action:@selector(itemsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [_itemsView addSubview:button];
        }
        
        _popItemsView = [CustomPopOverView new];
        _popItemsView.content = _itemsView;
    }
    return _popItemsView;
}

- (NSMutableArray *)deviceArray {
    if (!_deviceArray) {
        _deviceArray = [NSMutableArray new];
    }
    return _deviceArray;
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [collectionView showContentWithMessage:@"未发现设备!\n请点击右上角\"设置\"按钮\"发现设备\"" image:[UIImage imageNamed:@"未发现设备图标"] forNumberOfItemsInSection:self.deviceArray.count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify_DeviceCell forIndexPath:indexPath];
    cell.data = self.deviceArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

@end
