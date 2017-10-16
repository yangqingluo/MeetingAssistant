//
//  UIImage+BitmapData.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/10/16.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (BitmapData)

- (NSData *)bitmapData;
- (NSData *)bitmapFileHeaderData;
- (NSData *)bitmapDataWithFileHeader;

@end
