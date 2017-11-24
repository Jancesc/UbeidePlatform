//
//  NGGPreGuessListViewController.m
//  sport
//
//  Created by Jan on 27/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//
#import "NGGPreGuessListViewController.h"
#import "NGGDateListView.h"
#import "NGGTypeTableViewCell.h"
#import "NGGPreGameTableViewCell.h"
#import "NGGGuessDetailViewController.h"
#import "NGGGameResultView.h"
#import "Masonry.h"
#import "NGGRankView.h"

static NSString *kTypeCellIdentifier = @"NGGTypeTableViewCell";
static NSString *kPreGameCellIdentifier = @"NGGPreGameTableViewCell";

@interface NGGPreGuessListViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    NGGGameResultView *_resultView;
    
    NGGRankView *_rankView;
}
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeTableViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UITableView *typeTableView;

@property (weak, nonatomic) IBOutlet UITableView *gameTableView;
@property (weak, nonatomic) IBOutlet NGGDateListView *dateScrollView;
@end


@implementation NGGPreGuessListViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"赛前竞猜";
    [self configueUIComponents];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClicked)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configueUIComponents {
    
    self.navigationController.navigationBar.hidden = NO;
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0xfe, 0xa9, 0x03)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    _segmentControl.tintColor = NGGSeparatorColor;
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateSelected];
    [_segmentControl setSelectedSegmentIndex:0];
    _segmentControl.layer.borderColor = [NGGSeparatorColor CGColor];
    _segmentControl.layer.cornerRadius = 5.f;
    _segmentControl.clipsToBounds = YES;
    _segmentControl.layer.borderWidth = 1.f;
    
    _typeTableView.separatorColor = UIColorWithRGB(0xda, 0xda, 0xda);
    [_typeTableView setLayoutMargins:UIEdgeInsetsZero];
    [_typeTableView setSeparatorInset:UIEdgeInsetsZero];
    _typeTableView.backgroundColor = [UIColor clearColor];
    _typeTableView.separatorColor = NGGSeparatorColor;
    _typeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _typeTableView.rowHeight = 55.f;
    _typeTableView.delegate = self;
    _typeTableView.dataSource = self;
    _typeTableView.layer.borderColor = [NGGSeparatorColor CGColor];
    _typeTableView.layer.borderWidth = 0.5f;
    _typeTableView.showsVerticalScrollIndicator = NO;
    [_typeTableView registerNib:[UINib nibWithNibName:@"NGGTypeTableViewCell" bundle:nil] forCellReuseIdentifier:kTypeCellIdentifier];
    
    _gameTableView.separatorColor = UIColorWithRGB(0xda, 0xda, 0xda);
    _gameTableView.backgroundColor = [UIColor clearColor];
    _gameTableView.separatorColor = NGGSeparatorColor;
    _gameTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _gameTableView.rowHeight = 144.f;
    _gameTableView.delegate = self;
    _gameTableView.dataSource = self;
    [_gameTableView registerNib:[UINib nibWithNibName:@"NGGPreGameTableViewCell" bundle:nil] forCellReuseIdentifier:kPreGameCellIdentifier];
    [self refreshDateList];
    _typeTableViewWidthConstraint.constant = 125.0 * SCREEN_WIDTH / 375;
    
    _resultView = [NGGGameResultView new];
    _resultView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_resultView];
    [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_separatorView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    _rankView = [NGGRankView new];;
    _rankView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_rankView];
    [_rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_separatorView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}


#pragma mark - private methods

- (void)refreshDateList {
    
    _dateScrollView.dateInfo = nil;
}

- (void)leftBarButtonClicked {
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_typeTableView]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTypeCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    if ([tableView isEqual:_gameTableView]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPreGameCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    return nil;
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

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return 70.f;
//}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NGGGuessDetailViewController *controller = [[NGGGuessDetailViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

@end
