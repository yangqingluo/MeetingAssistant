//
//  RoomDetailViewController.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/14.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "RoomDetailViewController.h"
#import "JXTAlertController.h"
#import "ZYQAssetPickerController.h"

#import "SocketConnect.h"
#import "UICollectionView+Empty.h"
#import "DeviceCell.h"
#import "CustomPopOverView.h"
#import "UIButton+ImageAndText.h"
#import "SummaryView.h"
#import "DeviceStyleView.h"
#import "BlockActionSheet.h"
#import "BlockAlertView.h"
#import "EaseMessageReadManager.h"
#import "UIImage+BitmapData.h"

#import <AVFoundation/AVFoundation.h>

static NSString *identify_DeviceCell = @"DeviceCell";

@interface RoomDetailViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZYQAssetPickerControllerDelegate>

@property (strong, nonatomic) CustomPopOverView *popItemsView;
@property (strong, nonatomic) SummaryView *summaryView;
@property (strong, nonatomic) DeviceStyleView *styleView;

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) ZYQAssetPickerController *imageFromSystemPicker;

@end

@implementation RoomDetailViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SocketConnect getInstance] stopSearchingDevices];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self.collectionView registerClass:[DeviceCell class] forCellWithReuseIdentifier:identify_DeviceCell];
    self.collectionView.alwaysBounceVertical = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceNotification:) name:kNotification_DeviceRefresh object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketNotification:) name:kNotification_Socket object:nil];
}

- (void)setupNav {
    [self createNavWithTitle:[UserPublic getInstance].selectedRoomInfo.room_name createMenuItem:^UIView *(int nIndex){
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
//            NSArray *m_array = @[@{@"ip_address" : @"192.168.0.01", @"device_name" : @"张书记", @"summary" : @[@"image1", @"image2"], @"lighted" : @YES, @"state" : @0},
//                                 @{@"ip_address" : @"192.168.0.05", @"device_name" : @"刘德全", @"lighted" : @NO, @"state" : @1},
//                                 @{@"ip_address" : @"192.168.0.07", @"device_name" : @"李逵", @"lighted" : @NO, @"state" : @1},
//                                 @{@"ip_address" : @"192.168.0.11", @"device_name" : @"刘爱丽", @"summary" : @[@"image1", @"image2"], @"lighted" : @YES, @"state" : @2},
//                                 @{@"ip_address" : @"192.168.0.25", @"device_name" : @"王哲东", @"lighted" : @YES, @"state" : @2}];
            
            [self showHudInView:self.view hint:@"发现中..."];
            [[SocketConnect getInstance] startSearchingDevices];
        }
            break;
            
        case 1: {
            [self.summaryView showInView:self.view];
        }
            break;
            
        case 2: {
            [self.styleView showInView:self.view];
        }
            break;
            
        default:
            break;
    }
}

- (void)requestAccessForMedia:(NSUInteger)buttonIndex{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [self chooseHeadImage:buttonIndex];
            }
            else{
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus != AVAuthorizationStatusAuthorized){
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"选项中，允许%@访问您的相机",[AppPublic getInstance].appName] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    return;
                }
            }
            
        });
    }];
}

- (void)chooseHeadImage:(NSUInteger)buttonIndex{
    UIImagePickerControllerSourceType type = (buttonIndex == 1) ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:type]){
        if (buttonIndex == 1) {
            self.imagePicker.sourceType = type;
            QKWEAKSELF;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakself presentViewController:weakself.imagePicker animated:YES completion:^{
                    
                }];
                
            }];
        }
        else {
            _imageFromSystemPicker = nil;
            self.imageFromSystemPicker.maximumNumberOfSelection = 9 - [UserPublic getInstance].summaryArray.count;
            
            QKWEAKSELF;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakself presentViewController:weakself.imageFromSystemPicker animated:YES completion:^{
                    
                }];

            }];
        }
    }
    else{
        NSString *name = (buttonIndex == 1) ? @"相机" : @"照片";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@不可用", name] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)doEditDeviceNameAction:(NSString *)nameString indexPath:(NSIndexPath *)indexPath {
    if (!nameString.length) {
        [self showHint:@"名称不能为空"];
        return;
    }
    APPDeviceInfo *device = [UserPublic getInstance].selectedRoomInfo.deviceArray[indexPath.row];
    NSDictionary *m_dic = [UserPublic getInstance].fontArray[[UserPublic getInstance].selectedRoomInfo.styleInfo.index];
    CGFloat scale = [UIScreen mainScreen].scale;
    UILabel *m_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 800 / scale, 480 / scale)];
    m_label.font = [UIFont fontWithName:m_dic[@"name"] size:[UserPublic getInstance].selectedRoomInfo.styleInfo.fontSize];
    m_label.textColor = [UIColor blackColor];
    m_label.textAlignment = NSTextAlignmentCenter;
    m_label.text = nameString;
    UIImage *image = [AppPublic viewToImage:m_label];
    [[SocketConnect getInstance] updateDeviceNameImage:UIImageJPEGRepresentation(image, 1.0) host:device.host];
//    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);    
//    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"1.jpg"];
//    [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:YES];
//    
//    NSString *filePath1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"2.bmp"];
//    [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath1 atomically:YES];
//    
//    NSString *filePathBMP = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"test.bmp"];
//    [[image bitmapDataWithFileHeader] writeToFile:filePathBMP atomically:YES];
//    
//    NSString *filePathBMP1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"test1.bmp"];
//    [[image bitmapDataWithFileHeader] writeToFile:filePathBMP atomically:YES];
//    [[image convertUIImageToBitmapRGBA8:image] writeToFile:filePathBMP1 atomically:YES];;
    
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

- (SummaryView *)summaryView {
    if (!_summaryView) {
        _summaryView = [[SummaryView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    }
    return _summaryView;
}

- (DeviceStyleView *)styleView {
    if (!_styleView) {
        _styleView = [[DeviceStyleView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    }
    return _styleView;
}

- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (ZYQAssetPickerController *)imageFromSystemPicker{
    if (!_imageFromSystemPicker) {
        _imageFromSystemPicker = [[ZYQAssetPickerController alloc] init];
        _imageFromSystemPicker.assetsFilter = [ALAssetsFilter allPhotos];
        _imageFromSystemPicker.showEmptyGroups = NO;
        _imageFromSystemPicker.delegate = self;
        _imageFromSystemPicker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
    }
    
    return _imageFromSystemPicker;
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [collectionView showContentWithMessage:@"未发现设备!\n请点击右上角\"设置\"按钮\"发现设备\"" image:[UIImage imageNamed:@"未发现设备图标"] forNumberOfItemsInSection:[UserPublic getInstance].selectedRoomInfo.deviceArray.count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify_DeviceCell forIndexPath:indexPath];
    cell.data = [UserPublic getInstance].selectedRoomInfo.deviceArray[indexPath.row];
    cell.indexPath = indexPath;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
}

#pragma mark UIImagePickerControllerDelegate协议的方法
//用户点击图像选取器中的“cancel”按钮时被调用，这说明用户想要中止选取图像的操作
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//用户点击选取器中的“choose”按钮时被调用，告知委托对象，选取操作已经完成，同时将返回选取图片的实例
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // 图片类型
    if([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        //编辑后的图片
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        //如果想之后立刻调用UIVideoEditor,animated不能是YES。最好的还是dismiss结束后再调用editor。
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UserPublic getInstance].summaryArray addObject:image];
            [self.summaryView.collectionView reloadData];
        }];
    }
}

#pragma mark - ZYQAssetPickerController Delegate
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (ALAsset *asset in assets) {
                [[UserPublic getInstance].summaryArray addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
            }
            [self.summaryView.collectionView reloadData];
        });
        
    });
}

#pragma UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo{
    if ([eventName isEqualToString:Event_SummaryCellClicked]) {
        NSUInteger index = [(NSNumber *)userInfo integerValue];
        if (index == 0) {
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:@"添加图片" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex == 1) {
                    [weakself requestAccessForMedia:buttonIndex];
                }
                else if (buttonIndex == 2) {
                    [weakself chooseHeadImage:buttonIndex];
                }
            } otherButtonTitles:@"拍照", @"从相册选取", nil];
            [sheet showInView:self.view];
        }
        else {
            [[EaseMessageReadManager defaultManager] showBrowserWithImages:[UserPublic getInstance].summaryArray currentPhotoIndex:index - 1];
        }
    }
    else if ([eventName isEqualToString:Event_SummaryRemoveBtnClicked]) {
        NSInteger index = [(NSNumber *)userInfo integerValue] - 1;
        if (index >= 0 && index < [UserPublic getInstance].summaryArray.count) {
            [[UserPublic getInstance].summaryArray removeObjectAtIndex:index];
            [self.summaryView.collectionView reloadData];
        }
        
    }
    else if ([eventName isEqualToString:Event_DeviceCellLightButton]) {
        NSIndexPath *indexPath = (NSIndexPath *)userInfo;
        if (indexPath.row < [UserPublic getInstance].selectedRoomInfo.deviceArray.count) {
            APPDeviceInfo *device = [UserPublic getInstance].selectedRoomInfo.deviceArray[indexPath.row];
            
            [self showHudInView:self.view hint:nil];
            [[SocketConnect getInstance] operationLightOpen:!device.lighted host:device.host port:device.port];
        }
    }
    else if ([eventName isEqualToString:Event_DeviceCellLoadButton]) {
        NSIndexPath *indexPath = (NSIndexPath *)userInfo;
        if (indexPath.row < [UserPublic getInstance].selectedRoomInfo.deviceArray.count) {
            
            [self jxt_showAlertWithTitle:@"设置名称" message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker
                .addActionCancelTitle(@"取消")
                .addActionDefaultTitle(@"确定");
                [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"请输入名牌显示的名称";
                }];
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                if (buttonIndex == 1) {
                    UITextField *textField = alertSelf.textFields.firstObject;
                    [self doEditDeviceNameAction:textField.text indexPath:indexPath];
                }
            }];
        }
    }
}

#pragma mark - notification
- (void)deviceNotification:(NSNotification*)notification {
    [self.collectionView reloadData];
}

- (void)socketNotification:(NSNotification*)notification {
    [self hideHud];
    
    NSDictionary *m_dic = notification.object;
    int cmd = [m_dic[@"cmd"] intValue];
    switch (cmd) {
        case socket_cmdTimeout:{
            [self showHint:@"命令超时"];
        }
            break;
        case socket_searchDone:{
//            BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"共发现%d个设备", (int)[UserPublic getInstance].selectedRoomInfo.deviceArray.count] cancelButtonTitle:@"确定" clickButton:^(NSInteger buttonIndex) {
//            }otherButtonTitles:nil];
//            [alert show];
            
            [self jxt_showAlertWithTitle:[NSString stringWithFormat:@"共发现%d个设备", (int)[UserPublic getInstance].selectedRoomInfo.deviceArray.count] message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker
                .addActionCancelTitle(@"确定");
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                
            }];

        }
            break;
            
        case RESP_OPERATION_LIGHT_OPEN:
        case RESP_OPERATION_LIGHT_CLOSE:{
            BOOL result = [m_dic[@"result"] boolValue];
            [self showHint:result ? @"操作成功" : @"操作失败" ];
            [self.collectionView reloadData];
        }
            break;
            
        default:
            break;
    }
}

@end
