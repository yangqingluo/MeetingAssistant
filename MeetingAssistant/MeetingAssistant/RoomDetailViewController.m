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

static NSString *identify_DeviceCell = @"DeviceCell";

@interface RoomDetailViewController ()

@property (strong, nonatomic) AddFriendView *addFriedView;

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
            [btn setFrame:CGRectMake(screen_width - 64, 0, 64, 44)];
            [btn addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editButtonAction {
    if (!_addFriedView) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"AddFriendView" owner:self options:nil] ;
        _addFriedView = (AddFriendView *)[nib objectAtIndex:0];
        _addFriedView.frame=CGRectMake(self.view.bounds.size.width-125, 0, 121, 138);
        _addFriedView.hidden=YES;
        [self.view addSubview:_addFriedView];
    }
    _addFriedView.hidden = !_addFriedView.hidden;
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

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [collectionView showContentWithMessage:@"未发现设备!\n请点击右上角\"设置\"按钮\"发现设备\"" image:[UIImage imageNamed:@"未发现设备图标"] forNumberOfItemsInSection:0];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify_DeviceCell forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
