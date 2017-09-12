//
//  PublicNavViewController.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicNavViewController.h"

@interface PublicNavViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation PublicNavViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.navigationBarHidden = true;
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.childViewControllers.count > 1;
}

@end
