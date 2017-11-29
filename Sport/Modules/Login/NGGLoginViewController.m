//
//  NGGLoginViewController.m
//  shelves
//
//  Created by Jan on 08/08/2017.
//  Copyright © 2017 niugaga. All rights reserved.
//

#import "NGGLoginViewController.h"
#import "NGGRegisterViewController.h"
#import "NGGSocial.h"

@interface NGGLoginViewController ()<UITextFieldDelegate> {

    IBOutlet UITextField *_accountField;
    IBOutlet UITextField *_passwordField;
    
    UIButton *_registerButton;
    
    IBOutlet UIButton *_loginButton;
    
    __weak IBOutlet UIView *_thirdPartyLoginView;
    __weak IBOutlet UIButton *_wechatLoginButton;
    __weak IBOutlet UIButton *_QQLoginButton;
    __weak IBOutlet UIButton *_weiboLoginButton;
}

@end

@implementation NGGLoginViewController

#pragma mark - view life circle

- (void)setupUIComponents {
    
    //construct account text field
    UIView *accLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 82, VIEW_H(_accountField))];
    accLeftView.backgroundColor = [UIColor clearColor];
    UILabel *accLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, VIEW_W(accLeftView)-15, VIEW_H(accLeftView))];
    accLabel.backgroundColor = [UIColor clearColor];
    accLabel.font = [UIFont systemFontOfSize:14];
    accLabel.textColor = UIColorWithRGB(0x70, 0x70, 0x70);
    [accLeftView addSubview:accLabel];
    accLabel.text = @"账号";
    
    _accountField.leftViewMode = UITextFieldViewModeAlways;
    _accountField.leftView = accLeftView;
    _accountField.delegate = self;
    _accountField.keyboardType = UIKeyboardTypeASCIICapable;
    _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountField.tintColor = NGGPrimaryColor;
    _accountField.delegate = self;
    _accountField.returnKeyType = UIReturnKeyNext;
    //construct password text field
    UIView *passLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 82, VIEW_H(_passwordField))];
    passLeftView.backgroundColor = [UIColor clearColor];
    UILabel *passLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, VIEW_W(passLeftView)-15, VIEW_H(passLeftView))];
    passLabel.backgroundColor = [UIColor clearColor];
    passLabel.font = [UIFont systemFontOfSize:14];
    passLabel.textColor = UIColorWithRGB(0x70, 0x70, 0x70);
    [passLeftView addSubview:passLabel];
    passLabel.text = @"密码";
    
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.leftView = passLeftView;
    _passwordField.delegate = self;
    _passwordField.keyboardType = UIKeyboardTypeAlphabet;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.secureTextEntry = YES;
    _passwordField.tintColor = NGGPrimaryColor;
    _passwordField.delegate = self;
    //construct login button
    [_loginButton setBackgroundImage:[UIImage imageWithColor:NGGPrimaryColor] forState:UIControlStateNormal];
    _loginButton.clipsToBounds = YES;
    _loginButton.layer.cornerRadius = 5.f;
    [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册  " style:UIBarButtonItemStylePlain target:self action:@selector(registerButtonClicked:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回 " style:UIBarButtonItemStylePlain target:self action:@selector(dismissButtonClicked:)];
    
    [_wechatLoginButton addTarget:self action:@selector(wechatLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_QQLoginButton addTarget:self action:@selector(QQLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_weiboLoginButton addTarget:self action:@selector(weiboLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"登录";
    [self setupUIComponents];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

}

#pragma mark - button actions

- (void)loginButtonClicked:(UIButton *) button {

    if (isStringEmpty(_accountField.text) ||
        isStringEmpty(_passwordField.text)) {
        
        [self showErrorHUDWithText:@"请先输入账号密码!"];
        return;
    }
    
    [self showLoadingHUDWithText:nil];
}

- (void)registerButtonClicked:(UIButton *) button {
    
    NGGRegisterViewController *controller = [[NGGRegisterViewController alloc] initWithNibName:@"NGGRegisterViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)dismissButtonClicked:(UIButton *) button {
 
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)wechatLoginButtonClicked:(UIButton *) button {

}

- (void)QQLoginButtonClicked:(UIButton *) button {
    
    [[NGGSocial sharedInstance] sendQQAuthorizeRequestCompletion:^(NSDictionary *info) {
        
        
    }];
}

- (void)weiboLoginButtonClicked:(UIButton *) button {
    
    [[NGGSocial sharedInstance] sendWeiboAuthorizeRequestCompletion:^(NSDictionary *info) {
        
    }];
}

#pragma mark - private

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)loginAction:(NSDictionary *)params {
    
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=user.login" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showLoadingHUDWithText:msg];
        }];
        if (dict) {
            
            [self handleLoginSuccess:dict];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

- (void)handleLoginSuccess:(NSDictionary *)info {
    
    [NGGLoginSession newSessionWithLoginInformation:info];
    [[NSNotificationCenter defaultCenter] postNotificationName:NGGUserDidLoginNotificationName object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:_accountField]) {
        
        [_passwordField becomeFirstResponder];
    } else {
        
        [self.view endEditing:YES];
    }
    return YES;
}

@end
