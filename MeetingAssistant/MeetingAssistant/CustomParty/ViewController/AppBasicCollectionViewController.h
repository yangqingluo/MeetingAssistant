//
//  AppBasicCollectionViewController.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicViewController.h"

@interface AppBasicCollectionViewController : AppBasicViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@end
