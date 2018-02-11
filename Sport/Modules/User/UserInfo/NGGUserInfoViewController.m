//
//  NGGUserInfoViewController.m
//  Sport
//
//  Created by Jan on 24/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGUserInfoViewController.h"
#import "NGGCommonCell.h"
#import "NGGCommonCellModel.h"
#import "NGGModifyNicknameViewController.h"
#import "NGGNavigationController.h"
#import "NGGModifyPasswordViewController.h"
#import "NGGMessageViewController.h"
#import "ZSBlockAlertView.h"
@interface NGGUserInfoViewController()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    UITableView *_tableView;
    
    UIButton *_logoutButton;
}

@property (nonatomic, strong) NSArray *infoArray;

@end

@implementation NGGUserInfoViewController

#pragma mark - view life circle

-(void)loadView {
    
    self.view = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
    [self configueUIComponents];
}

- (void)configueUIComponents {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 55.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [_tableView registerNib:[UINib nibWithNibName:KCommonImageCellNibName bundle:nil] forCellReuseIdentifier:KCommonImageTableViewCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:KCommonTextCellNibName bundle:nil] forCellReuseIdentifier:KCommonTextTableViewCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:KCommonSwitchCellNibName bundle:nil] forCellReuseIdentifier:KCommonSwitchTableViewCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:_tableView];
    
    UIView *footetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    [footetView setBackgroundColor:[UIColor clearColor]];
    _logoutButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    [_logoutButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_logoutButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    _logoutButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_logoutButton setTitleColor:NGGColor666 forState:UIControlStateNormal];
    [_logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footetView addSubview:_logoutButton];
    
    _tableView.tableFooterView = footetView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)refreshData {
    
    NGGUser *currentUser = [NGGLoginSession activeSession].currentUser;
    
    NGGCommonCellModel *model_0 = [NGGCommonCellModel new];
    model_0.title = @"头像";
    model_0.type = NGGCommonCellTypeImage;
    model_0.value =currentUser.avatarURL;
    
    NGGCommonCellModel *model_1 = [NGGCommonCellModel new];
    model_1.title = @"昵称";
    model_1.value = currentUser.nickname;
    model_1.type = NGGCommonCellTypeText;

    NGGCommonCellModel *model_2 = [NGGCommonCellModel new];
    model_2.title = @"性别";
    model_2.value = [currentUser.sex isEqualToString:@"1"] ? @"男" : @"女";
    model_2.type = NGGCommonCellTypeText;

    NGGCommonCellModel *model_3 = [NGGCommonCellModel new];
    model_3.title = @"消息";
    model_3.desc = @"投注比赛结果推送";
    model_3.value = [@([NGGUser gameResultNotificationEnable]) stringValue] ;
    model_3.type = NGGCommonCellTypeSwitch;

    NGGCommonCellModel *model_4 = [NGGCommonCellModel new];
    model_4.title = @"密码";
    model_4.desc = @"修改登录密码";
    model_4.type = NGGCommonCellTypeText;

    _infoArray = @[@[model_0],
                   @[model_1, model_2, model_3, model_4]];
    
    [_tableView reloadData];
}

#pragma mark - button actions

- (void)logoutButtonClicked:(UIButton *) button {
    
    ZSBlockAlertView *alertView = [[ZSBlockAlertView alloc] initWithTitle:@"确定退出当前账号？" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
    [alertView setClickHandler:^(NSInteger index) {
       
        if (index == 1) {
            [NGGLoginSession destroyActiveSession];
            [[NSNotificationCenter defaultCenter] postNotificationName:NGGUserDidLogoutNotificationName object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [alertView show];
}

#pragma mark - private methods

- (void)modifyAvatar:(UIImage *)image {
    
    [self showLoadingHUDWithText:nil];
    NGGUser *currentUser = [NGGLoginSession activeSession].currentUser;
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=user.modifyInfo" parameters:@{@"uid" : currentUser.uid, @"token" : currentUser.token} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData: imageData name: @"photo" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            NSString *avatar = [dict stringForKey:@"avatar_img"];
            [NGGLoginSession activeSession].currentUser.avatarURL= avatar;
            [[NGGLoginSession activeSession].currentUser saveToDisk];
            [[NSNotificationCenter defaultCenter] postNotificationName:NGGUserDidModifyUserInfoNotificationName object:nil];
            [self refreshData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

- (void)modifyNickname:(NSString *)nickname {
    
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=user.modifyInfo" parameters:@{@"nickname" : nickname} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            [NGGLoginSession activeSession].currentUser.nickname= dict[@"nickname"];
            [[NGGLoginSession activeSession].currentUser saveToDisk];
            [[NSNotificationCenter defaultCenter] postNotificationName:NGGUserDidModifyUserInfoNotificationName object:nil];
            [self refreshData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

- (void)modifySex:(NSString *)sex {
    
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=user.modifyInfo" parameters:@{@"sex" : sex} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            [NGGLoginSession activeSession].currentUser.sex = dict[@"sex"];
            [[NGGLoginSession activeSession].currentUser saveToDisk];
            [[NSNotificationCenter defaultCenter] postNotificationName:NGGUserDidModifyUserInfoNotificationName object:nil];
            [self refreshData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

- (void)modifyGameResultNotification:(BOOL)on {
 
    if (on) {
        
        UIUserNotificationType type = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        if (type == UIUserNotificationTypeNone) { //并未打开开关
            
            ZSBlockAlertView *alertView = [[ZSBlockAlertView alloc] initWithTitle:@"设置推送权限" message:@"需要先打开推送权限，才能及时推送比赛结果" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
            [alertView setClickHandler:^(NSInteger index) {
                
                if (index == 1) {
                    
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    } else {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }];
            [alertView show];
        } else {
            
        }
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    } else if (section == 1) {
        
        return 4;
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *sectionArray = _infoArray[indexPath.section];
    NGGCommonCellModel *model = sectionArray[indexPath.row];
    NGGCommonTableViewCell *cell = nil;
    if (model.type == NGGCommonCellTypeImage) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:KCommonImageTableViewCellIdentifier forIndexPath:indexPath];
    } else if (model.type == NGGCommonCellTypeText) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:KCommonTextTableViewCellIdentifier forIndexPath:indexPath];
    } else if (model.type == NGGCommonCellTypeSwitch) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:KCommonSwitchTableViewCellIdentifier forIndexPath:indexPath];
        NGGSwitchTableViewCell *switchCell = (NGGSwitchTableViewCell *)cell;
        switchCell.valueChanged = ^(BOOL change) {
            
            [self modifyGameResultNotification:change];
        };
    }
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.01f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
            [actionSheet showInView:self.view];
        }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        
        NGGModifyNicknameViewController *controller = [[NGGModifyNicknameViewController alloc] initWithNibName:@"NGGModifyNicknameViewController" bundle:nil];
        controller.maxCount = 20;
        controller.model = _infoArray[indexPath.section][indexPath.row];
        controller.completion = ^(NSString *text) {
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [self modifyNickname:text];
        } ;
        
        NGGNavigationController *nav = [[NGGNavigationController alloc] initWithRootViewController:controller];;
        [self.navigationController presentViewController:nav animated:YES completion:^{
        
        }];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        // 准备初始化配置参数
        NSString *title = @"设置性别";
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
       
            [self modifySex:@"1"];
        }];
        
        UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
       
            [self modifySex:@"2"];

        }];
        [actionSheet addAction:maleAction];
        [actionSheet addAction:femaleAction];
        [self presentViewController:actionSheet animated:YES completion:nil];
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        
        NGGModifyPasswordViewController *controller = [[NGGModifyPasswordViewController alloc] initWithNibName:@"NGGModifyPasswordViewController" bundle:nil];
        NGGNavigationController *nav = [[NGGNavigationController alloc] initWithRootViewController:controller];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self modifyAvatar:image];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.allowsEditing = YES;
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.navigationBar.tintColor = [UIColor whiteColor];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else if (1 == buttonIndex)
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.allowsEditing = YES;
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.navigationBar.tintColor = [UIColor whiteColor];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

@end


