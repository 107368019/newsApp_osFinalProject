//
//  ViewController.m
//  finalProject
//
//  Created by taizhou on 2018/12/11.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import "ViewController.h"
#import "DataManager/DataManager.h"
#import "newsTableViewCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DataManager *dataManager;
@property (strong, nonatomic) NSMutableArray<NSMutableArray<content_newsReq*>*> *contentsArr;
@property (strong, nonatomic) NSMutableArray<content_newsReq*> *showContents;
@property (strong, nonatomic) NSMutableArray<UIImage*> *imgArr;
@property (strong, nonatomic) IBOutlet UIStackView *typeStackview;
@property (strong, nonatomic) IBOutlet UIScrollView *newsScrollview;

@property (strong, nonatomic) IBOutlet UIView *newsImgView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageCtrl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataManager = [DataManager getInstance];
    [self tableViewInit];
    [self arrayInit];
    [self stackviewAndScrollviewInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //註冊推播
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataManagerNotification:) name:@"dataManager" object:nil];
    
    
    for (int i=0; i<7; i++) {
        int type=(i==6)?i+4:i+3;
        [self doGetNewsWithType:type];
    }
    
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
- (void)arrayInit{
    _imgArr= [NSMutableArray<UIImage*> new ];
    _contentsArr=[NSMutableArray<NSMutableArray<content_newsReq*>*> new ];
    for (int i=0; i<7; i++) {
        NSMutableArray<content_newsReq*> *contents=[NSMutableArray<content_newsReq*> new ];
        [_contentsArr addObject:contents];
    }
}

- (void)tableViewInit{
    _tableView.delegate=self;
    _tableView.dataSource=self;
}

- (void)stackviewAndScrollviewInit{
    for (int i=0; i<7; i++) {
//        UIButton *btn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        UIButton *btn= [[UIButton alloc]init];
        btn.tag=i;
        btn.titleLabel.text=[NSString stringWithFormat:@"445346%d",i];
        btn.backgroundColor=[UIColor blueColor];
        [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_typeStackview addArrangedSubview:btn];
    }

    CGFloat width=_newsImgView.frame.size.width;
    CGFloat height=_newsImgView.frame.size.height;
    _newsScrollview.contentSize=CGSizeMake(width*10, height);
    _newsScrollview.delegate=self;
    for (int i=0; i<10; i++) {
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(i*width, 0, width,  height)];
         [imgView setImage:[UIImage imageNamed:@"homeCubee"]];
        imgView.contentMode=UIViewContentModeScaleAspectFit;
        [_newsScrollview addSubview:imgView];
    }
}

- (void)doGetNewsWithType:(int)type{
    newsReq *req=[[newsReq alloc]initWithaccountID:@"test" lastIndex:-1 count:20 type:@[@(type)]];
    [_dataManager getNews:req];
}

- (void)handleGetNews:(newsRes *)res{
    if(res.status==0){
        int type=res.results.content[0].type;
        int index=(type==10)?type-4:type-3;
        [_contentsArr[index] addObjectsFromArray:res.results.content];
        
        if(type==3){
            _showContents=_contentsArr[index];
             [_tableView reloadData];
        }
        
        
        
//        for (int i=0; i<res.results.content.count; i++) {
//            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:res.results.content[i].imageUrl]]];
//            [_imgArr addObject:image];
//        }
//
    }
}

- (void)typeBtnClick:(UIButton*)btn{
    _showContents=_contentsArr[btn.tag];
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    cell.textLabel.text=_res.results.content[indexPath.row].title;
    
    newsTableViewCell *cell = (newsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"newsTableViewCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"newsTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    [cell setCell:_showContents[indexPath.row] img:nil];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showContents.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat screenWidth = scrollView.frame.size.width;
    NSInteger currentPage = ((scrollView.contentOffset.x - screenWidth/2)/screenWidth)+1;
    [_pageCtrl setCurrentPage:currentPage];
}

@end
