//
//  NGGModifyPasswordViewController.m
//  Sport
//
//  Created by Jan on 27/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGModifyPasswordViewController.h"

@interface NGGModifyPasswordViewController () {

    
    IBOutlet UITextField *_verificationCodeField;
    
    IBOutlet UITextField *_passwordField;
    IBOutlet UITextField *_repeatPasswordField;
    IBOutlet UIButton *_confirmButton;
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
    veriButton.titleLabel.font = [UIFont systemFontOfSize:12];
    veriButton.layer.cornerRadius = 3.f;
    veriButton.clipsToBounds = YES;
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
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - button actions

- (void)confirmButtonClicked:(UIButton *) button {
    
    NSLog(@"confirmButtonClicked");
}


@end
