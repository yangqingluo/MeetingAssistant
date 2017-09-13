//
//  MeetingRoomsViewController.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "MeetingRoomsViewController.h"
#import "JXTAlertController.h"

#import "UICollectionView+Empty.h"
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
        alertMaker
        .addActionCancelTitle(@"取消")
        .addActionDefaultTitle(@"确定");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 1) {
            [[AppPublic getInstance] logout];
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
    [self jxt_showAlertWithTitle:@"创建会议室" message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker
        .addActionCancelTitle(@"取消")
        .addActionDefaultTitle(@"确定");
        [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入会议室名称";
        }];
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 1) {
            UITextField *textField = alertSelf.textFields.firstObject;
            [self doCreatMeetingRoomAction:textField.text];
        }
    }];
}

- (void)doCreatMeetingRoomAction:(NSString *)nameString {
    if (!nameString.length) {
        [self showHint:@"会议室名称不能为空"];
        return;
    }
    
    
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [collectionView showContentWithMessage:@"未添加会议室\n请点击右上角\"添加\"按钮" image:[UIImage imageNamed:@"空状态图标"] forNumberOfItemsInSection:0];
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
