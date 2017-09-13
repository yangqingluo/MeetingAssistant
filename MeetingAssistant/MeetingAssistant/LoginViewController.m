//
//  LoginViewController.m
//  MeetingAssistant
//
//  Created by 7kers on 2017/9/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)dealloc{
    [self.usernameTextField removeObserver:self forKeyPath:@"text"];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateBackgroundImageIsLandscape:UIInterfaceOrientationIsLandscape(toInterfaceOrientation)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL isLandscape = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
    [self updateBackgroundImageIsLandscape:isLandscape];
    CGFloat orientationWidth = isLandscape ? 1024 : 768;
    CGFloat orientationHeight = isLandscape ? 768 : 1024;
    CGFloat topY = 136 * screen_height / orientationHeight;
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"登录界面logo"]];
    logoView.center = CGPointMake(0.5 * screen_width, topY + 0.5 * logoView.height);
    [self.view addSubview:logoView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, logoView.bottom + 40, screen_width, 24)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont fontWithName:@"JLinXin" size:24];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"会议小助手";
    [self.view addSubview:nameLabel];
    
    float inputHeight = 50;
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, nameLabel.bottom + 58, 390 * screen_width / orientationWidth, inputHeight * 2 + 20)];
    inputView.centerX = 0.5 * screen_width;
    inputView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:inputView];
    
    self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, inputView.width, inputHeight)];
    self.usernameTextField.centerY = 0.5 * inputHeight;
    self.usernameTextField.placeholder = @"请输入用户名";
    [inputView addSubview:self.usernameTextField];
    [self addTextField:self.usernameTextField imageName:@"用户名图标"];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, inputView.width, inputHeight)];
    self.passwordTextField.bottom = inputView.height;
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.secureTextEntry = YES;
    [inputView addSubview:self.passwordTextField];
    [self addTextField:self.passwordTextField imageName:@"密码图标"];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(inputView.left, inputView.bottom + 50, inputView.width, 50);
    [loginButton setBackgroundImage:[UIImage imageNamed:@"登录按钮背景"] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    [AppPublic roundCornerRadius:loginButton];
    
    [self.usernameTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.usernameTextField.text = [ud objectForKey:kUserName];
    
    [AppPublic autoresizeMaskFlexibleLeftAndRightMargin:logoView];
    [AppPublic autoresizeMaskFlexibleLeftAndRightMargin:nameLabel];
    [AppPublic autoresizeMaskFlexibleLeftAndRightMargin:inputView];
    [AppPublic autoresizeMaskFlexibleLeftAndRightMargin:loginButton];
}

- (void)addTextField:(UITextField *)textField imageName:(NSString *)imageName{
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.font = [UIFont systemFontOfSize:16.0];
    textField.textColor = [UIColor whiteColor];
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    textField.backgroundColor = RGBA(0xff, 0xff, 0xff, 0.2);
    [AppPublic roundCornerRadius:textField];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, textField.height)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.center = CGPointMake(0.6 * leftView.width, 0.5 * leftView.height);
    [leftView addSubview:imageView];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, textField.height)];
    rightView.backgroundColor = [UIColor clearColor];
    
    if ([textField isEqual:self.usernameTextField]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"输入清楚按钮"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 40, 40);
        btn.center = CGPointMake(0.4 * rightView.width, 0.5 * rightView.height);
        [rightView addSubview:btn];
        btn.tag = 10;
        [btn addTarget:self action:@selector(textFiledBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([textField isEqual:self.passwordTextField]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"密码可见"] forState:UIControlStateSelected];
        btn.frame = CGRectMake(0, 0, 40, 40);
        btn.center = CGPointMake(0.4 * rightView.width, 0.5 * rightView.height);
        [rightView addSubview:btn];
        btn.tag = 11;
        [btn addTarget:self action:@selector(textFiledBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    textField.rightView = rightView;
}

- (void)loginAction{
    [self.view endEditing:YES];
    
    if (self.usernameTextField.text.length == 0) {
        [self showHint:@"请输入用户名"];
    }
    else if (self.passwordTextField.text.length < kPasswordLengthMin) {
        [self showHint:@"请输入正确的密码"];
    }
    else {
        [self showHudInView:self.view hint:nil];
        
        QKWEAKSELF;
        [[QKNetworkSingleton sharedManager] loginWithID:self.usernameTextField.text Password:self.passwordTextField.text completion:^(id responseBody, NSError *error){
            [weakself hideHud];
            if (error) {
                [weakself showHint:error.userInfo[@"message"]];
            }
        }];
    }
}

- (void)textFiledBtnAction:(UIButton *)button {
    switch (button.tag) {
        case 10: {
            self.usernameTextField.text = nil;
            [self.usernameTextField becomeFirstResponder];
        }
            break;
            
        case 11: {
            button.selected = !button.selected;
            self.passwordTextField.secureTextEntry = !button.selected;
        }
            break;
            
        default:
            break;
    }
}

- (void)updateBackgroundImageIsLandscape:(BOOL)isLandscape {
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:isLandscape ? @"登录页面背景图-横版" : @"登录界面竖版背景图"].CGImage);
}

#pragma mark - textfield
- (void)textFieldDidChange :(UITextField *)textField{
    textField.rightViewMode = textField.text.length ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger length = 32;
    return range.location < length;
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"text"]){
        if ([object isEqual:self.usernameTextField]) {
            [self textFieldDidChange:object];
        }
    }
}

@end
