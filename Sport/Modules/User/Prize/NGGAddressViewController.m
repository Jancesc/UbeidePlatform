//
//  NGGAddressViewController.m
//  Sport
//
//  Created by jan on 26/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGAddressViewController.h"
#import "UITextView+Placeholder.h"
#import "ZSBlockAlertView.h"
@interface NGGAddressViewController ()<UITextViewDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UITextView *_addressTextView;
    __weak IBOutlet UITextField *_nameTextfield;
    __weak IBOutlet UIButton *_confirmButton;
    __weak IBOutlet UITextField *_phoneTextfield;
}

@end

@implementation NGGAddressViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"收货信息";
    [self setupUIComponents];
}

- (void)setupUIComponents {
    
    _addressTextView.placeholder = @"请输入详细地址";
    _addressTextView.placeholderColor = NGGColorCCC;
    _addressTextView.tintColor = NGGPrimaryColor;
    _phoneTextfield.tintColor = NGGPrimaryColor;
    _phoneTextfield.placeholder = @"请输入手机号";
    _nameTextfield.tintColor = NGGPrimaryColor;
    _nameTextfield.placeholder = @"请输入收件人姓名";
    
    _confirmButton.layer.cornerRadius = 5.f;
    _confirmButton.clipsToBounds = YES;
    [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton setBackgroundImage:[UIImage imageWithColor:NGGThirdColor] forState:UIControlStateNormal];

    self.view.backgroundColor = NGGGlobalBGColor;
    
    _addressTextView.returnKeyType = UIReturnKeyNext;
    _addressTextView.delegate = self;
    _phoneTextfield.returnKeyType = UIReturnKeyNext;
    _phoneTextfield.delegate = self;
    _nameTextfield.returnKeyType = UIReturnKeyDone;
    _nameTextfield.delegate = self;
    if (_dictOfAddress) {
        
//        "phone": "18565556202",
//        "consignee": "啊啊啊",
//        "address": "北京市,市辖区,东城区 啊啊啊"
        _addressTextView.text = [_dictOfAddress stringForKey:@"address"];
        _phoneTextfield.text = [_dictOfAddress stringForKey:@"phone"];
        _nameTextfield.text = [_dictOfAddress stringForKey:@"consignee"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - button actions

- (void)confirmButtonClicked:(UIButton *) button {

    if(isStringEmpty(_addressTextView.text)||
       isStringEmpty(_phoneTextfield.text)||
       isStringEmpty(_nameTextfield.text)) {
        
        [self showErrorHUDWithText:@"请填写完整信息"];
        return;
    }
    
    ZSBlockAlertView *alertView = [[ZSBlockAlertView alloc] initWithTitle:@"确定信息填写无误？" message:nil cancelButtonTitle:@"否" otherButtonTitles:@[@"是"]];
    [alertView setClickHandler:^(NSInteger index) {
        
        if (index == 1) {
            
            [self showLoadingHUDWithText:nil];
            [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=goods.exchange" parameters:@{@"order_id" : [_prizeInfo stringForKey:@"order_id"], @"consignee" : _nameTextfield.text, @"phone" : _phoneTextfield.text, @"address" : _addressTextView.text} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                
                [self dismissHUD];
                
                BOOL success = [self noData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
                
                    [self showErrorHUDWithText:msg];
                }];
                if (success) {
                    
                    [self showAlertText:@"成功填写收货信息，我们会尽快安排发货，请注意查收！" completion:^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                [self dismissHUD];
            }];
        }
    }];
    [alertView show];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]){
        
        [_phoneTextfield becomeFirstResponder];
        
        return NO;
        
    }
    return YES;
    
}

#pragma mark - UITextfield

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:_phoneTextfield]) {
        
        [_nameTextfield becomeFirstResponder];
    } else {
    
        [self.view endEditing:YES];
    }
    return YES;
}
@end
