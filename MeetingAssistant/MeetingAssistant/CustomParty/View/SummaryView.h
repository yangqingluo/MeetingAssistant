//
//  SummaryView.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SideBarView.h"

#define Event_SummaryCellClicked @"SummaryCellClicked"
#define Event_SummaryRemoveBtnClicked @"Event_SummaryRemoveBtnClicked"
@interface SummaryView : SideBarView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@end
