//
//  AppPublic.h
//
//  Created by yangqingluo on 16/9/9.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIImage+Color.h"
#import "UIViewController+HUD.h"
#import "AppType.h"
#import "QKNetworkSingleton.h"
//json解析
#import "MJExtension.h"
//下拉刷新
#import "MJRefresh.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

#define QKWEAKSELF typeof(self) __weak weakself = self;

#define RGBA(R, G, B, A) [UIColor colorWithRed:R / 255.f green:G / 255.f blue:B / 255.f alpha:A]

#define MainColor                    RGBA(0x2C, 0x2E, 0x37, 1.0)
#define AuxiliaryColor               RGBA(0x00, 0x97, 0xa7, 1.0)
#define baseSeparatorColor           RGBA(0xdb, 0xdb, 0xdb, 1.0)
#define baseSeparatorAlphaColor      RGBA(0xdb, 0xdb, 0xdb, 0.6)

#define baseRedColor                 RGBA(0xd9, 0x55, 0x55, 1.0)
#define baseBlueColor                RGBA(0x00, 0x84, 0xff, 1.0)
#define lightWhiteColor              RGBA(0xf8, 0xf8, 0xf8, 1.0)
#define silverColor                  RGBA(0xc0, 0xc0, 0xc0, 1.0)
#define baseTextColor                RGBA(0x33, 0x33, 0x33, 1.0)

#define STATUS_HEIGHT                20.0
#define STATUS_BAR_HEIGHT            64.0
#define TAB_BAR_HEIGHT               49.0
#define DEFAULT_BAR_HEIGHT           44.0

#define appRefreshTime               24 * 60 * 60//自动刷新间隔时间
#define kButtonCornerRadius          4.0
#define kCellHeight                  44.0
#define kCellHeightFilter            50.0
#define kCellHeightMiddle            60.0
#define kCellHeightBig               80.0
#define kCellHeightHuge              100.0

#define imageDataMax                 1 * 1024 * 1024//图像大小上限
#define headImageSizeMax             96//头像图像 宽/高 大小上限

#define appButtonTitleFontSize       14.0
#define appLabelFontSize             14.0
#define appLabelFontSizeMiddle       16.0
#define appSeparaterLineSize         1.0//分割线尺寸
#define appPageSize                  20//获取分页数据时分页size

#define kEdgeSmall                   5.0
#define kEdge                        10.0
#define kEdgeMiddle                  15.0
#define kEdgeBig                     20.0
#define kEdgeHuge                    30.0


#define cellDetailLeft               (kEdgeMiddle + 80 + kEdge)
#define cellDetailRightWhenIndicator (screen_width - kEdgeHuge)

#define kPhoneNumberLength           0x0b
#define kVCodeNumberLength           0x06
#define kPasswordLengthMin           0x03
#define kPasswordLengthMax           0x10
#define kNameLengthMax               0x30
#define kNumberLengthMax             0x09
#define kInputLengthMax              0x60

#define NumberWithoutPoint           @"0123456789"
#define NumberWithPoint              @"0123456789."

#define kUserName                    @"username_CRM"
#define kUserData                    @"userdata_CRM"

#define defaultHeadImageName         @"默认头像"
#define kNotifi_Customer_Refresh     @"kNotification_Customer_Refresh_CRM"
#define kNotifi_Order_Refresh        @"kNotification_Order_Refresh_CRM"
#define kNotifi_RMoney_Refresh       @"kNotification_RMoney_Refresh_CRM"

//result is [from to]
#define RandomInAggregate(from, to) ((int)(from + (arc4random() % (to - from + 1))))

typedef enum : NSUInteger {
    PowerType_CustomerManagement = 1,
    PowerType_OrderManagement    = 4,
    PowerType_FollowUpRecord     = 0,
} PowerType;

typedef void(^DoneBlock)(NSObject *object);

@interface AppPublic : NSObject

//应用名称
@property (strong, nonatomic) NSString *appName;

+ (AppPublic *)getInstance;

/*!
 @brief 检查版本是否第一次使用
 */
BOOL isFirstUsing();

/*!
 @brief 检查字符串是否是手机号码
 */
BOOL isMobilePhone(NSString *string);

/*!
 @brief 检查字符串是否是邮件地址
 */
BOOL isEmailAdress(NSString *string);

/*!
 @brief sha1加密
 */
NSString *sha1(NSString *string);

/*!
 @brief 替换空字符串
 */
NSString *notNilString(NSString *string);

//图像压缩
NSData *dataOfImageCompression(UIImage *image, BOOL isHead);

UIButton *NewBackButton(UIColor *color);
UIButton *NewTextButton(NSString *title, UIColor *textColor);

//日期-文本转换
NSDate *dateFromString(NSString *dateString, NSString *format);
NSString *stringFromDate(NSDate *date, NSString *format);

+ (NSString *)standardTimeStringWithTString:(NSString *)string;
+ (NSString *)standardTimeStringWithTString:(NSString *)string originalDateFormat:(NSString *)oFormat destinationalDateFormat:(NSString *)dFormat;

//文本尺寸
+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantWidth:(CGFloat)width;
+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantHeight:(CGFloat)height;
+ (void)adjustLabelWidth:(UILabel *)label;
+ (void)adjustLabelHeight:(UILabel *)label;
+ (UIFont *)appFontOfSize:(CGFloat)fontSize;
+ (UIFont *)appFontOfPxSize:(CGFloat)pxSize;

//切圆角
+ (void)roundCornerRadius:(UIView *)view;
+ (void)roundCornerRadius:(UIView *)view cornerRadius:(CGFloat)radius;

//设置视图autoresizingMask
+ (void)autoresizeMaskFlexibleLeftAndRightMargin:(UIView *)view;

//顶部状态栏颜色
+ (void)changeStatusBarLightContent:(BOOL)isWhite;

//判断类是否有某属性
+ (BOOL)getVariableWithClass:(Class)myClass varName:(NSString *)name;

- (void)logout;
- (void)loginDoneWithUserData:(NSDictionary *)data username:(NSString *)username password:(NSString *)password;

- (void)goToMainVC;
- (void)goToLoginCompletion:(void (^)(void))completion;

@end
