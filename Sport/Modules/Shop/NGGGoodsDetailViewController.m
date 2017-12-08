//
//  NGGGoodsDetailViewController.m
//  Sport
//
//  Created by Jan on 07/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGoodsDetailViewController.h"
#import "PSCarouselView.h"

@interface NGGGoodsDetailViewController ()<PSCarouselDelegate> {
    
    __weak IBOutlet PSCarouselView *_carouselView;
    
    __weak IBOutlet UITextView *_textView;
    __weak IBOutlet UIButton *_submitButton;
    __weak IBOutlet UIButton *_InfoButton;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_countLabel;
}

@end

@implementation NGGGoodsDetailViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configueUIComponents];
    self.view.backgroundColor = NGGGlobalBGColor;
    [self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)configueUIComponents {
  
    _carouselView.pageDelegate = self;
    _carouselView.imageURLs = @[@"http://www.hangge.com/blog_uploads/201707/2017072719181777126.png"];
    
    NSMutableAttributedString *mAttributedString = [NSMutableAttributedString new];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 16.f;
    style.lineSpacing = 3.f;
    style.paragraphSpacing = 5.f;
    NSAttributedString *titleAttributedString = [[NSAttributedString alloc] initWithString:@"金豆抽奖声明" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName : NGGColor333, NSParagraphStyleAttributeName : style}];
    
    NSAttributedString *contentAttributedString = [[NSAttributedString alloc] initWithString:@"\n1. 抽奖活动的原则是公平、公正、公开\n2. 奖项在截止时间内无其他限制，每个奖项用户可参加多次\n3. 每抽奖一次消耗对应的金豆，中奖结果立即公布\n4. 实物奖品请在领奖截止期内领取，过期作废\n5. 请仔细填写收货地址、联系方式，因收货地址信息有误造成的快递配送失败，奖品视为作废\n6. 虚拟奖品以虚拟卡号的形式由系统自动发放到用户中奖纪录中\n7. 本活动最终解释权归本公司所有" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : NGGColor333, NSParagraphStyleAttributeName : style}];
 
    [mAttributedString appendAttributedString:titleAttributedString];
    [mAttributedString appendAttributedString:contentAttributedString];
    _textView.attributedText = [mAttributedString copy];
    _textView.contentInset = UIEdgeInsetsMake(15, 0, 15, 0);
    _textView.contentOffset = CGPointMake(-200, -200);
    _textView.editable = NO;
    [_InfoButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    [_InfoButton addTarget:self action:@selector(handleInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton addTarget:self action:@selector(handleSubmitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshUI {
    
    _carouselView.imageURLs = @[[_goodsInfo stringForKey:@"goods_pic"]];
    _nameLabel.text = [_goodsInfo stringForKey:@"goods_name"];
    _countLabel.text = [_goodsInfo stringForKey:@"need_bean"];
}

#pragma mark - button actions

- (void)handleInfoButtonClicked:(UIButton *) button {
    
}

- (void)handleSubmitButtonClicked:(UIButton *) button {
    
}

@end
