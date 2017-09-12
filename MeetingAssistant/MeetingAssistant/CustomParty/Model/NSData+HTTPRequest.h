//
//  NSData+HTTPRequest.h
//
//  Created by yangqingluo on 16/4/22.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HTTPRequest)
- (NSString*)base64EncodingWithLineLength:(unsigned int)lineLength;
- (NSString *)getImageType;
- (NSString *)typeForImage;
- (BOOL)isJPG;
- (BOOL)isPNG;
- (BOOL)isGIF;
@end
