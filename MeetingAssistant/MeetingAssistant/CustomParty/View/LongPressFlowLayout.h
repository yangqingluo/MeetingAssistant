//
//  LongPressFlowLayout.h
//  SchoolIM
//
//  Created by yangqingluo on 16/6/11.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LongPressFlowLayout : UICollectionViewFlowLayout <UIGestureRecognizerDelegate>

@property (strong, nonatomic, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;


@end


@protocol LongPressCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>
@optional

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;

@end