//
//  SummaryView.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SummaryView.h"
#import "LongPressFlowLayout.h"
#import "SummaryCell.h"
#import "BlockAlertView.h"
#import "UIResponder+Router.h"

static NSString *identify = @"imageCell_Summary";

@implementation SummaryView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createNavWithTitle:@"会议纪要" createMenuItem:^UIView *(int nIndex){
            if (nIndex == 0){
                UIButton *btn = NewBackButton(nil);
                [btn setTitle:@"关闭" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:17];
                [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
                self.backButton = btn;
                return btn;
            }
            else if (nIndex == 1){
                UIButton *btn = NewTextButton(@"保存", [UIColor whiteColor]);
                [btn setFrame:CGRectMake(self.baseView.width - 64, 0, 54, 44)];
                [btn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
                self.saveButton = btn;
                return btn;
            }
            
            return nil;
        }];
        
        [self.baseView addSubview:self.collectionView];
    }
    return self;
}

- (void)saveButtonAction {
    [self dismiss];
}

- (void)imageRemoveButtonClick:(UIButton *)sender{
    [self routerEventWithName:Event_SummaryRemoveBtnClicked userInfo:@(sender.tag)];
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        NSUInteger countH = 2;
        LongPressFlowLayout *flowLayout = [[LongPressFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.headerReferenceSize = CGSizeMake(0, 16);
        flowLayout.footerReferenceSize = CGSizeMake(0, 10);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 16;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 14, 0, 14);
        double width = (self.baseView.width - 2 * 14 - (countH - 1) * flowLayout.minimumInteritemSpacing) / countH;
        flowLayout.itemSize = CGSizeMake(width, width);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, self.baseView.width, self.baseView.height - STATUS_BAR_HEIGHT) collectionViewLayout:flowLayout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[SummaryCell class] forCellWithReuseIdentifier:identify];
    }
    
    return _collectionView;
}

#pragma mark - collection view
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self routerEventWithName:Event_SummaryCellClicked userInfo:@(indexPath.row)];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [UserPublic getInstance].summaryArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SummaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.imgView.backgroundColor = [UIColor clearColor];
    cell.removeButton.tag = indexPath.row;
    [cell.removeButton addTarget:self action:@selector(imageRemoveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row > 0) {
        cell.imgView.image = [UserPublic getInstance].summaryArray[indexPath.row - 1];
        cell.removeButton.hidden = NO;
    }
    else{
        cell.imgView.image = [UIImage imageNamed:@"添加图标按钮"];
        cell.removeButton.hidden = YES;
    }
    
    return cell;
}


@end
