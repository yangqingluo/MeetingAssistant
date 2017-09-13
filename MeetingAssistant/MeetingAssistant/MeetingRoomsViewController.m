//
//  MeetingRoomsViewController.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "MeetingRoomsViewController.h"
#import "JXTAlertController.h"

#import "MeetingRoomCell.h"
#import "BlockAlertView.h"

static NSString *identify_MeetingRoomCell = @"MeetingRoomCellCell";

@interface MeetingRoomsViewController ()

@end

@implementation MeetingRoomsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self.collectionView registerClass:[MeetingRoomCell class] forCellWithReuseIdentifier:identify_MeetingRoomCell];
}

- (void)setupNav {
    [self createNavWithTitle:@"会议室管理" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"创建会议室按钮"] forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(screen_width - 64, 0, 64, 44)];
            [btn addTarget:self action:@selector(creatButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
}

- (void)goBack{
    [self jxt_showAlertWithTitle:@"确定要退出账号？" message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionCancelTitle(@"取消").
        addActionDestructiveTitle(@"确定");
        [alertMaker alertAnimateDisabled];
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 1) {
            [self logoutAction];
        }
    }];
    
//    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定要退出账号？" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
//        if (buttonIndex == 1) {
//            [self logoutAction];
//        }
//    }otherButtonTitles:@"确定", nil];
//    [alert show];
}

- (void)creatButtonAction {
    
}

- (void)logoutAction {
    [self showHudInView:self.view hint:nil];
    [[AppPublic getInstance] logout];
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MeetingRoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify_MeetingRoomCell forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.width / 2.0, collectionView.width / 2.0 + 44);
}
//定义每个UICollectionView 的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
