//
//  NGGRegisterViewController.m
//  shelves
//
//  Created by Jan on 08/08/2017.
//  Copyright © 2017 niugaga. All rights reserved.
//

#import "NGGRegisterViewController.h"

@interface NGGRegisterViewController ()<UITextFieldDelegate> {
    
    IBOutlet UITextField *_accountField;
    IBOutlet UITextField *_verificationCodeField;

    IBOutlet UITextField *_passwordField;
    IBOutlet UITextField *_invitationField;

    IBOutlet UIButton *_registerButton;
}

@end

@implementation NGGRegisterViewController

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
    accLabel.text = @"手机号";
    
    _accountField.leftViewMode = UITextFieldViewModeAlways;
    _accountField.leftView = accLeftView;
    _accountField.delegate = self;
    _accountField.keyboardType = UIKeyboardTypePhonePad;
    _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_accountField becomeFirstResponder];

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
    [veriButton setTitle:@"获取验证码" forState:UIControlStateNormal];
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
    passLabel.text = @"密码";
    
    
    UIView *passRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, VIEW_H(_passwordField))];
    passRightView.backgroundColor = [UIColor clearColor];
    UIButton *visiblieButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, VIEW_H(passRightView))];
    visiblieButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [visiblieButton setImage:[UIImage imageNamed:@"password_visible"] forState:UIControlStateNormal];
    [visiblieButton setImage:[UIImage imageNamed:@"password_unvisible"] forState:UIControlStateSelected];
    [visiblieButton addTarget:self action:@selector(visibleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [passRightView addSubview:visiblieButton];
    
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.leftView = passLeftView;
    _passwordField.rightViewMode = UITextFieldViewModeAlways;
    _passwordField.rightView = passRightView;
    _passwordField.delegate = self;
    _passwordField.keyboardType = UIKeyboardTypeAlphabet;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.secureTextEntry = YES;
    
    //construct invitation text field
    UIView *inviLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 82, VIEW_H(_invitationField))];
    inviLeftView.backgroundColor = [UIColor clearColor];
    UILabel *inviLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, VIEW_W(inviLeftView)-15, VIEW_H(inviLeftView))];
    inviLabel.backgroundColor = [UIColor clearColor];
    inviLabel.font = [UIFont systemFontOfSize:14];
    inviLabel.textColor = UIColorWithRGB(0x70, 0x70, 0x70);
    [inviLeftView addSubview:inviLabel];
    inviLabel.text = @"邀请码";
    
    _invitationField.leftViewMode = UITextFieldViewModeAlways;
    _invitationField.leftView = inviLeftView;
    _invitationField.delegate = self;
    _invitationField.keyboardType = UIKeyboardTypeAlphabet;
    _invitationField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    //construct login button
    [_registerButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    _registerButton.clipsToBounds = YES;
    _registerButton.layer.cornerRadius = 5.f;
    [_registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"注册绑定";
    [self setupUIComponents];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - button actions

- (void)registerButtonClicked:(UIButton *) button {
    
    NSLog(@"registerButtonClicked");
}

- (void)visibleButtonClicked:(UIButton *) button {
    
    button.selected = !button.selected;
    _passwordField.secureTextEntry = !button.selected;

}

- (IBAction)protocolButtonClicked:(UIButton *)sender {
}
@end
