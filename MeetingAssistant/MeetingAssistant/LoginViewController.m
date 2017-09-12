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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"登录页面背景图-横版"].CGImage);
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"登录界面logo"]];
    if (logoView.width > 0.25 * screen_width) {
        logoView.frame = CGRectMake(0, 0, 0.25 * screen_width, 0.25 * screen_width);
    }
    logoView.center = CGPointMake(0.5 * screen_width, 136 + 0.5 * logoView.height);
    [self.view addSubview:logoView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, logoView.bottom + 40, screen_width, 24)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont fontWithName:@"JLinXin" size:24];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"会议小助手";
    [self.view addSubview:nameLabel];
    
    float inputHeight = 50;
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, nameLabel.bottom + 58, screen_width * 390 / 1024, inputHeight * 2 + 20)];
    inputView.centerX = 0.5 * screen_width;
    inputView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:inputView];
    
    self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, inputView.width, inputHeight)];
    self.usernameTextField.centerY = 0.5 * inputHeight;
    self.usernameTextField.placeholder = @"请输入用户名";
    self.usernameTextField.font = [UIFont systemFontOfSize:16.0];
    self.usernameTextField.textColor = [UIColor whiteColor];
    [self.usernameTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.usernameTextField.backgroundColor = RGBA(0xff, 0xff, 0xff, 0.2);
    self.usernameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.usernameTextField.clearButtonMode = UITextFieldViewModeAlways;
    [inputView addSubview:self.usernameTextField];
    [self addTextField:self.usernameTextField imageName:@"用户名图标"];
    [AppPublic roundCornerRadius:self.usernameTextField];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, inputView.width, inputHeight)];
    self.passwordTextField.bottom = inputView.height;
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.font = [UIFont systemFontOfSize:14.0];
    self.passwordTextField.textColor = [UIColor whiteColor];
    [self.passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.passwordTextField.backgroundColor = RGBA(0xff, 0xff, 0xff, 0.2);
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    [inputView addSubview:self.passwordTextField];
    [self addTextField:self.passwordTextField imageName:@"密码图标"];
    [AppPublic roundCornerRadius:self.passwordTextField];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(inputView.left, inputView.bottom + 50, inputView.width, 50);
    [loginButton setBackgroundImage:[UIImage imageNamed:@"登录按钮背景"] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.usernameTextField.text = [ud objectForKey:kUserName];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)addTextField:(UITextField *)textField imageName:(NSString *)imageName{
    textField.delegate = self;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, textField.height)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.center = CGPointMake(0.6 * leftView.width, 0.5 * leftView.height);
    [leftView addSubview:imageView];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
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
            if (!error) {
                if (isHttpSuccess([responseBody[@"Status"] intValue])) {
                    
                }
                else {
                    [weakself showHint:responseBody[@"Msg"]];
                }
            }
            else{
                [weakself showHint:@"网络出错"];
            }
        }];
    }
}

#pragma textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger length = 32;
    return range.location < length;
}

@end
