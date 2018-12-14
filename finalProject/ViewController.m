//
//  ViewController.m
//  finalProject
//
//  Created by taizhou on 2018/12/11.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import "ViewController.h"
#import "DataManager/DataManager.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DataManager *dataManager;
@property (strong, nonatomic) newsRes *res;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataManager = [DataManager getInstance];
     [self tableViewInit];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //註冊推播
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataManagerNotification:) name:@"dataManager" object:nil];
    [self doGetNews];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dataManager" object:nil];
    
}
#pragma mark - notification
- (void)dataManagerNotification:(NSNotification *)notification {
    MethodResponse *methodResponse = [notification object];
    
    if ([methodResponse.methodName isEqualToString:@"getNews"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleGetNews:(newsRes *)methodResponse.object];
        });
    }
}
#pragma mark - init
- (void)tableViewInit{
    _tableView.delegate=self;
    _tableView.dataSource=self;
}

- (void)doGetNews{
    newsReq *req=[[newsReq alloc]initWithaccountID:@"test" lastIndex:-1 count:20 type:@[@(2)]];
    [_dataManager getNews:req];
}

- (void)handleGetNews:(newsRes *)res{
    if(res.status==0){
        _res=res;
        [_tableView reloadData];
    }
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text=_res.results.content[indexPath.row].title;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _res.results.content.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


@end
