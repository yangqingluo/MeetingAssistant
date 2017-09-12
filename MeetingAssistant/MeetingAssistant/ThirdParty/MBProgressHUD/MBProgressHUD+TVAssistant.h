//
//  MBProgressHUD+TVAssistant.h
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (TVAssistant)

-(void)showToastWithText:(NSString *)text;
-(void)showToastWithText:(NSString *)text whileExecutingBlock:(dispatch_block_t)block;
+(MBProgressHUD *)showToastToView:(UIView *)view withText:(NSString *)text;
+(MBProgressHUD *)showToastNoHideClearColorToView:(UIView *)view withText:(NSString *)text textColor:(UIColor *)textColor;

@end
