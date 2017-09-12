//
//  AppBasicCollectionViewController.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicCollectionViewController.h"
#import "LongPressFlowLayout.h"

@interface AppBasicCollectionViewController ()

@end

@implementation AppBasicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        NSUInteger countH = 2;
        double width = (screen_width - (countH + 1) * kEdgeMiddle) / countH;
        
        LongPressFlowLayout *flowLayout = [[LongPressFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        flowLayout.footerReferenceSize = CGSizeMake(0, 0);
        flowLayout.itemSize = CGSizeMake(width, width + 60);
        //        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = kEdgeSmall;
        flowLayout.sectionInset = UIEdgeInsetsMake(kEdgeSmall, kEdgeMiddle, 0, kEdgeMiddle);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, screen_width, self.view.height - STATUS_BAR_HEIGHT) collectionViewLayout:flowLayout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
