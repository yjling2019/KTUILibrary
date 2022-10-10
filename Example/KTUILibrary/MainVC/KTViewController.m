//
//  KTViewController.m
//  KTUILibrary
//
//  Created by KOTU on 12/07/2021.
//  Copyright (c) 2021 KOTU. All rights reserved.
//

#import "KTViewController.h"
#import <Masonry/Masonry.h>

#import "KTImageLabelVC.h"
#import "KTEdgesLabelVC.h"
#import "KTEdgesTextFieldVC.h"

@interface KTViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *vcs;

@end

@implementation KTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Demo";
    
//    self.navigationController.navigationBar.delegate = self;
    self.navigationController.navigationBar.translucent = NO;
    
    self.vcs = @[
        @[@"ImageLabel" , @"KTImageLabelVC"],
        @[@"EdgesLabel" , @"KTEdgesLabelVC"],
        @[@"EdgeTextField" , @"KTEdgesTextFieldVC"],
		@[@"imageSave", @"KTSaveImageVC"],
    ];

    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UINavigationBarDelegate
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vcs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.vcs[indexPath.row][0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *clsName = self.vcs[indexPath.row][1];
    UIViewController *vc = [[NSClassFromString(clsName) alloc] init];
    vc.title = self.vcs[indexPath.row][0];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _tableView;
}

@end
