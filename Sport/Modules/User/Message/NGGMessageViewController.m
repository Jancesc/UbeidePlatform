//
//  NGGMessageViewController.m
//  Sport
//
//  Created by Jan on 27/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGMessageViewController.h"
#import "NGGSystemMessageViewController.h"
#import "NGGEmptyView.h"

@interface NGGMessageViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}

@end

@implementation NGGMessageViewController

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
    self.title = @"消息中心";
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"messageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = NGGColor999;
    }
    if (indexPath.row == 0) {
        
        cell.imageView.image = [UIImage imageNamed:@"message_01"];
        cell.textLabel.text = @"系统消息";
        cell.detailTextLabel.text = @"共有1508条系统消息";
        cell.textLabel.textColor = UIColorWithRGB(0xc8, 0x57, 0x22);
    } else {
     
        cell.imageView.image = [UIImage imageNamed:@"message_02"];
        cell.textLabel.text = @"赛事消息";
        cell.detailTextLabel.text =  @"共有1508条赛事消息";
        cell.textLabel.textColor = UIColorWithRGB(0x89, 0xcc, 0x5a);    }
    return cell;
}

#pragma mark - UITableViewDelegate
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
    
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row == 0) {
            
            NGGSystemMessageViewController *controller = [[NGGSystemMessageViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if (indexPath.row == 1) {

            NGGEmptyView *emptyView = [[NGGEmptyView alloc] initWithFrame:_tableView.bounds];
            _tableView.backgroundView = emptyView;
        }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
