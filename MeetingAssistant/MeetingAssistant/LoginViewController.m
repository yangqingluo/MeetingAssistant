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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    if (logoView.width > 0.25 * screen_width) {
        logoView.frame = CGRectMake(0, 0, 0.25 * screen_width, 0.25 * screen_width);
    }
    logoView.center = CGPointMake(0.5 * screen_width, 40 + 0.5 * logoView.height);
    [self.view addSubview:logoView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, logoView.bottom + 10, screen_width, 20)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:14.0];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"文轩零售事业部CRM系统";
    [self.view addSubview:nameLabel];
    
    float inputHeight = 50;
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, nameLabel.bottom + 30, screen_width, inputHeight * 2)];
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];
    
    self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(kEdge, 0, inputView.width - 2 * kEdge, 44)];
    self.usernameTextField.centerY = 0.5 * inputHeight;
    self.usernameTextField.placeholder = @"请输入用户名";
    self.usernameTextField.font = [UIFont systemFontOfSize:14.0];
    self.usernameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.usernameTextField.clearButtonMode = UITextFieldViewModeAlways;
    [inputView addSubview:self.usernameTextField];
    [self addTextField:self.usernameTextField imageName:@"用户名"];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(kEdge, 0, inputView.width - 2 * kEdge, 44)];
    self.passwordTextField.centerY = 1.5 * inputHeight;
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.font = [UIFont systemFontOfSize:14.0];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    [inputView addSubview:self.passwordTextField];
    [self addTextField:self.passwordTextField imageName:@"密码"];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, inputView.width, 1)];
    lineView.backgroundColor = baseSeparatorColor;
    lineView.center = CGPointMake(0.5 * inputView.width, 0.5 * inputView.height);
    [inputView addSubview:lineView];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(kEdgeBig, inputView.bottom + 30, screen_width - 2 * kEdgeBig, 40);
    loginButton.backgroundColor = baseRedColor;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    loginButton.layer.cornerRadius = kButtonCornerRadius;
    loginButton.layer.masksToBounds = YES;
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
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, textField.height)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.centerY = 0.5 * leftView.height;
    imageView.image = [UIImage imageNamed:imageName];
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
