//
//  NGGSystemMessageViewController.m
//  Sport
//
//  Created by Jan on 27/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGSystemMessageViewController.h"
#import "NGGSystemMessageTableViewCell.h"

static NSString *kSystemMessageTableViewCellIdentifier = @"wystemMessageTableViewCellIdentifier";
@interface NGGSystemMessageViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}
@property (nonatomic, strong) NSArray *arrayOfMessage;
@end

@implementation NGGSystemMessageViewController

- (void)loadView {
    
    self.view = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - HOME_INDICATOR) style: UITableViewStyleGrouped];
    _tableView.separatorColor = NGGSeparatorColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 75.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [_tableView registerNib:[UINib nibWithNibName:@"NGGSystemMessageTableViewCell" bundle:nil] forCellReuseIdentifier:kSystemMessageTableViewCellIdentifier];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统消息";
    [self configueData];
}


- (void)configueData {
    
    _arrayOfMessage = @[
                        @{
                            @"date" : @"",
                            @"content" : @"出来时就不会被计算高度了。这是因为从 iOS7 开始，iOS7 中引入了 Dynamic Type 的功能，这个功能使得用户可以调整应用中字体的大小，而 iOS7 中的所有系统应用都适配了这个功能需求。但是从 iOS8 开始，Apple 希望所有的应用都可以适配这个功能需求，于是就取消了 Cell 在自动算高时的高度缓存",
                            @"user_img" : @"http://upload.jianshu.io/users/upload_avatars/737583/c6ff9abb68c3.png?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96"
                            },
                        @{
                            @"date" : @"",
                            @"content" : @"算过高度，那么它下一次滑动出来时就不会被计算高度了。这是因为从 iOS7 开始，iOS7 中引入了 Dynamic Type 的功能，这个功能使得用户可以调整应用中字体的大小，而 iOS7 中的所有系统应用都适配了这个功能需求。但是从 iOS8 开始，Apple 希望所有的应用都可以适配这个功能需求，于是就取消了 Cell 在自动算高时的高度缓存",
                            @"user_img" : @"http://upload.jianshu.io/users/upload_avatars/737583/c6ff9abb68c3.png?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96"
                            },
                        @{
                            @"date" : @"",
                            @"content" : @"如的高度缓存如的高度缓存如的\n高度缓存如的高度缓存",
                            @"user_img" : @"http://upload.jianshu.io/users/upload_avatars/737583/c6ff9abb68c3.png?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96"
                            },
                        @{
                            @"date" : @"",
                            @"content" : @"如的高度缓存",
                            @"user_img" : @"http://upload.jianshu.io/users/upload_avatars/737583/c6ff9abb68c3.png?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96"
                            },
                        @{
                            @"date" : @"",
                            @"content" : @"高度\n，你就会发现一\n\n旦 Cell 在之前被\n计算过\n高度，那么它下\n一次滑动出来时就不会被计算高\n度了。这是因为\n从 iOS7 开始，iOS7\n 中\n引入了 \nDynamic Type 的功能，这个\n功能使得用户可以调整应\n用中字体的大小，而 iOS7 中的\n所有系统应用都适配了这个功能需求。但是从 iOS8 开\n始，Apple 希望所有的\n应用\n都可以适配这个功能需求，于是就\n取消了 \nCell 在自动算高时\n的高度缓存",
                            @"user_img" : @"http://upload.jianshu.io/users/upload_avatars/737583/c6ff9abb68c3.png?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96"
                            },
                        @{
                            @"date" : @"",
                            @"content" : @"这个功能使得用户可以调整应用中字体的大小，而 iOS7 中的所有系统应用都适配了这个功能需求。但是从 iOS8 开始，Apple 希望所有的应用都可以适配这个功能需求，于是就取消了 Cell 在自动算高时的高度缓存",
                            @"user_img" : @"http://upload.jianshu.io/users/upload_avatars/737583/c6ff9abb68c3.png?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96"
                            },
                        ];
    [_tableView reloadData];
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrayOfMessage count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGSystemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSystemMessageTableViewCellIdentifier forIndexPath:indexPath];
    cell.cellInfo = _arrayOfMessage[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [NGGSystemMessageTableViewCell rowHeightWithCellInfo:_arrayOfMessage[indexPath.row]];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
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

