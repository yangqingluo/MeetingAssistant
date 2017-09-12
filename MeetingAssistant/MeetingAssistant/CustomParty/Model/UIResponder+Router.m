//
//  UIResponder+Router.m
//  CRM2017
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end
