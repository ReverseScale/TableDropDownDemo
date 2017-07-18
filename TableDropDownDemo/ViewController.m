//
//  ViewController.m
//  TableDropDownDemo
//
//  Created by WhatsXie on 2017/7/18.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+HexColor.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView ;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableDictionary *flagDic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    [self setupData];
}
- (void)setupData {
    NSArray *dataArray = @[@[@"0",@"1",@"2",@"3",@"4"],
                           @[@"0",@"1",@"2",@"3",@"4"],
                           @[@"0",@"1",@"2",@"3",@"4"],
                           @[@"0",@"1",@"2",@"3",@"4"],
                           @[@"0",@"1",@"2",@"3",@"4"]
                           ];
    
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
    _flagDic  = [[NSMutableDictionary alloc] initWithCapacity:0];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - Table Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dataArray[section];
    NSString *flag = [_flagDic objectForKey:[NSString stringWithFormat:@"%ld",section]];
    
    if ([flag isEqualToString:@"YES"]) {
        return array.count;
    } else if ([flag isEqualToString:@"NO"]) {
        return 0;
    } else {
        return array.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    NSString *key = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:key] isEqualToString:@"YES"]) {
        cell.textLabel.text = @"选中";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *button = [UIButton new];
    button.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50);
    [button setTitle:[NSString stringWithFormat:@"%ld",section] forState:normal];
    [button setTitleColor:[UIColor blackColor] forState:normal];
    [button addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    button.tag = section;
    return button;
}

- (void)headerViewClick:(UIButton *)button {
    NSLog(@"section :%ld",button.tag);
    NSString *key = [NSString stringWithFormat:@"%ld",button.tag];
    if ([[_flagDic objectForKey:key] isEqualToString:@"NO"]) {
        [_flagDic setObject:@"YES" forKey:key];
    } else {
        [_flagDic setObject:@"NO" forKey:key];
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = @"选中";
    NSString *key = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:key] isEqualToString:@"YES"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:key];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
