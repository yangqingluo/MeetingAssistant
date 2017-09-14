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

- (instancetype)init{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    return self;
}

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
        NSUInteger countH = 3;
        LongPressFlowLayout *flowLayout = [[LongPressFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.headerReferenceSize = CGSizeMake(0, 20);
        flowLayout.footerReferenceSize = CGSizeMake(0, 10);
        flowLayout.minimumInteritemSpacing = 19;
        flowLayout.minimumLineSpacing = 25;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        double width = (screen_width - 2 * 16 - (countH - 1) * flowLayout.minimumInteritemSpacing) / countH;
        flowLayout.itemSize = CGSizeMake(width, 112);
        
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
