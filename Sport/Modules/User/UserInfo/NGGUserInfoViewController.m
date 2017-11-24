//
//  NGGUserInfoViewController.m
//  Sport
//
//  Created by Jan on 24/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGUserInfoViewController.h"
#import "NGGCommonCell.h"
#import "Masonry.h"
#import "NGGCommonCellModel.h"

@interface NGGUserInfoViewController()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
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
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
    }
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)refreshData {
    
    NGGCommonCellModel *model_0 = [NGGCommonCellModel new];
    model_0.title = @"头像";
    model_0.type = NGGCommonCellTypeImage;
    model_0.value = @"http://upload-images.jianshu.io/upload_images/927233-558062c2a3cd2ac9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";
    
    NGGCommonCellModel *model_1 = [NGGCommonCellModel new];
    model_1.title = @"昵称";
    model_1.value = @"游客";
    model_1.type = NGGCommonCellTypeText;

    NGGCommonCellModel *model_2 = [NGGCommonCellModel new];
    model_2.title = @"性别";
    model_2.value = @"男";
    model_2.type = NGGCommonCellTypeText;

    NGGCommonCellModel *model_3 = [NGGCommonCellModel new];
    model_3.title = @"消息";
    model_3.desc = @"投注比赛结果推送";
    model_3.value = @"0";
    model_3.type = NGGCommonCellTypeSwitch;

    NGGCommonCellModel *model_4 = [NGGCommonCellModel new];
    model_4.title = @"密码";
    model_4.desc = @"修改登录密码";
    model_4.type = NGGCommonCellTypeText;

    _infoArray = @[@[model_0],
                   @[model_1, model_2, model_3, model_4]];
    
    [_tableView reloadData];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (indexPath.row == 0)
    //    {
    //        DMAgencyAddBankAccountViewController *controller =
    //        [[DMAgencyAddBankAccountViewController alloc] initWithNibName:@"DMAgencyAddBankAccountViewController" bundle:nil];
    //        controller.delegate = self;
    //        [self.navigationController pushViewController:controller animated:YES];
    //    }
    //    else if (indexPath.row == 1)
    //    {
    //        DMAgencyAddAliPayAccountViewController *contoller = [[DMAgencyAddAliPayAccountViewController alloc] initWithNibName:@"DMAgencyAddAliPayAccountViewController" bundle:nil];
    //        contoller.delegate = self;
    //        [self.navigationController pushViewController:contoller animated:YES];
    //    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end


