//
//  NGGModifyPasswordViewController.m
//  Sport
//
//  Created by Jan on 27/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGModifyPasswordViewController.h"
#import <pop/pop.h>

@interface NGGModifyPasswordViewController ()<UITextFieldDelegate> {

    
    IBOutlet UITextField *_verificationCodeField;
    
    IBOutlet UITextField *_passwordField;
    IBOutlet UITextField *_repeatPasswordField;
    IBOutlet UIButton *_confirmButton;
    UIButton *_verificationButton;
    NSString *_taskID;

}
@end

@implementation NGGModifyPasswordViewController

#pragma mark - view life circle

- (void)setupUIComponents {
    
    //construct verification code text field
    UIView *veriLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 82, VIEW_H(_verificationCodeField))];
    veriLeftView.backgroundColor = [UIColor clearColor];
    UILabel *veriLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, VIEW_W(_verificationCodeField)-15, VIEW_H(veriLeftView))];
    veriLabel.backgroundColor = [UIColor clearColor];
    veriLabel.font = [UIFont systemFontOfSize:14];
    veriLabel.textColor = UIColorWithRGB(0x70, 0x70, 0x70);
    [veriLeftView addSubview:veriLabel];
    veriLabel.text = @"验证码";
    
    
    UIView *veriRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, VIEW_H(_verificationCodeField))];
    veriRightView.backgroundColor = [UIColor clearColor];
    UIButton *veriButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0.5 * (VIEW_H(veriRightView) - 30), 80, 30)];
    [veriButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [veriButton setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0x7a, 0xce, 0x51)] forState:UIControlStateNormal];
    [veriButton setBackgroundImage:[UIImage imageWithColor:NGGSeparatorColor] forState:UIControlStateDisabled];
    [veriButton setTitleColor:NGGViceColor forState:UIControlStateDisabled];
    veriButton.titleLabel.font = [UIFont systemFontOfSize:14];
    veriButton.layer.cornerRadius = 3.f;
    veriButton.clipsToBounds = YES;
    _verificationButton = veriButton;
    [veriButton addTarget:self action:@selector(verificationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [veriRightView addSubview:veriButton];
    
    _verificationCodeField.leftViewMode = UITextFieldViewModeAlways;
    _verificationCodeField.leftView = veriLeftView;
    _verificationCodeField.rightViewMode = UITextFieldViewModeAlways;
    _verificationCodeField.rightView = veriRightView;
    _verificationCodeField.delegate = self;
    _verificationCodeField.keyboardType = UIKeyboardTypeNumberPad;
    _verificationCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.secureTextEntry = YES;
    
    //construct password text field
    UIView *passLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 82, VIEW_H(_passwordField))];
    passLeftView.backgroundColor = [UIColor clearColor];
    UILabel *passLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, VIEW_W(passLeftView)-15, VIEW_H(passLeftView))];
    passLabel.backgroundColor = [UIColor clearColor];
    passLabel.font = [UIFont systemFontOfSize:14];
    passLabel.textColor = UIColorWithRGB(0x70, 0x70, 0x70);
    [passLeftView addSubview:passLabel];
    passLabel.text = @"新密码";
    
    
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.leftView = passLeftView;
    _passwordField.delegate = self;
    _passwordField.keyboardType = UIKeyboardTypeAlphabet;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.secureTextEntry = YES;
    
    //construct password text field
    UIView *repeatLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 82, VIEW_H(_repeatPasswordField))];
    repeatLeftView.backgroundColor = [UIColor clearColor];
    UILabel *repeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, VIEW_W(repeatLeftView)-15, VIEW_H(repeatLeftView))];
    repeatLabel.backgroundColor = [UIColor clearColor];
    repeatLabel.font = [UIFont systemFontOfSize:14];
    repeatLabel.textColor = UIColorWithRGB(0x70, 0x70, 0x70);
    [repeatLeftView addSubview:repeatLabel];
    repeatLabel.text = @"确认密码";
    
    _repeatPasswordField.leftViewMode = UITextFieldViewModeAlways;
    _repeatPasswordField.leftView = repeatLeftView;
    _repeatPasswordField.delegate = self;
    _repeatPasswordField.keyboardType = UIKeyboardTypeAlphabet;
    _repeatPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _repeatPasswordField.secureTextEntry = YES;
    
    //construct login button
    [_confirmButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    _confirmButton.clipsToBounds = YES;
    _confirmButton.layer.cornerRadius = 5.f;
    [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"修改密码";
    [self setupUIComponents];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClicked)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - private methods

- (void)leftBarButtonClicked{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil
     ];
}

#pragma mark - button actions

- (void)verificationButtonClicked:(UIButton *) button {
    
    [self.view endEditing:YES];
    button.enabled = NO;
    [self verificationCountDownAnimation];
    [self loadVerificationCode];
}

- (void)verificationCountDownAnimation {
    
    POPBasicAnimation *ani = [POPBasicAnimation linearAnimation];
    ani.property = [POPAnimatableProperty propertyWithName:@"countDown" initializer:^(POPMutableAnimatableProperty *prop) {
        
        [prop setWriteBlock:^(id obj, const CGFloat *values) {
            
            UIButton *button = obj;
            [button setTitle:[NSString stringWithFormat:@"%ld s", (NSInteger)values[0]] forState:UIControlStateDisabled];
        }];
    }];
    
    ani.fromValue = @(60);
    ani.toValue = @(1);
    ani.duration = 60;
    __weak UIButton *weakButton = _verificationButton;
    ani.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        
        weakButton.enabled = YES;
    };
    [_verificationButton pop_addAnimation:ani forKey:@"countDown"];
}

- (void)loadVerificationCode {
    
    [self showLoadingHUDWithText:nil];
    NGGUser *currentUser = [NGGLoginSession activeSession].currentUser;
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=user.sendSmsCode" parameters:@{@"task" : @"find_pwd", @"phone" : currentUser.phone} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            _taskID = [dict stringForKey:@"task_id"];
            _verificationCodeField.text = [dict stringForKey:@"code"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

- (void)confirmButtonClicked:(UIButton *) button {

    [self.view endEditing:YES];
    if (isStringEmpty(_verificationCodeField.text) ||
        isStringEmpty(_passwordField.text) ||
        isStringEmpty(_repeatPasswordField.text)) {
        
        [self showErrorHUDWithText:@"先填写完整的信息！"];
        return;
    }
    
    if (isStringEmpty(_taskID)) {
            
            [self showErrorHUDWithText:@"需要先获取手机验证码！"];
            return;
        }
    
    if (![_passwordField.text isEqualToString:_repeatPasswordField.text]) {
       
        [self showErrorHUDWithText:@"两次输入的密码不一致！"];
        return;
    }
    NSDictionary *params = @{
               @"password" : _passwordField.text,
               @"task_id" : _taskID,
               @"code" : _verificationCodeField.text,
               };
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=user.modifyPwd" parameters:params willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            [self showAlertText:@"成功修改密码!" completion:^{
            
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}


@end
