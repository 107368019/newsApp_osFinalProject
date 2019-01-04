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
#import "newsView.h"
#import "newsPopupViewController.h"
@import SafariServices;
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SFSafariViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DataManager *dataManager;
@property (strong, nonatomic) NSMutableArray<NSMutableArray<content_newsReq*>*> *contentsArr;
@property (strong, nonatomic) NSMutableArray<content_newsReq*> *showContents;

@property (strong, nonatomic) IBOutlet UIStackView *typeStackview;
@property (strong, nonatomic) IBOutlet UIScrollView *newsScrollview;

@property (strong, nonatomic) IBOutlet UIView *newsImgView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageCtrl;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) bool isFisrt;
@property (assign, nonatomic) dispatch_once_t onceToken;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataManager = [DataManager getInstance];
    [self tableViewInit];
    [self arrayInit];
    [self typeStackviewInit];
    _isFisrt=TRUE;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    //註冊推播
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataManagerNotification:) name:@"dataManager" object:nil];
    
    dispatch_once(&_onceToken, ^{
        //焦點新聞
        [self doGetNewsWithType:2];
        //其他類別
        for (int i=0; i<7; i++) {
            int type=(i==6)?i+4:i+3;
            [self doGetNewsWithType:type];
        }
    });    
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
    
    _contentsArr=[NSMutableArray<NSMutableArray<content_newsReq*>*> new ];
    for (int i=0; i<8; i++) {
        NSMutableArray<content_newsReq*> *contents=[NSMutableArray<content_newsReq*> new ];
        [_contentsArr addObject:contents];
    }
}

- (void)setTimer{
    __weak typeof(self)weakSelf=self;
    _timer=[NSTimer scheduledTimerWithTimeInterval:4 repeats:YES block:^(NSTimer *timer){
        __strong typeof(weakSelf)strongSelf=weakSelf;
        if(!strongSelf) return;
        [strongSelf scrollNews];
    }];
}

- (void)scrollNews{
    CGFloat width=_newsImgView.frame.size.width;
    CGFloat height=_newsImgView.frame.size.height;
    int index=(int)_pageCtrl.currentPage;
    if(index!=9){
        [_newsScrollview scrollRectToVisible:CGRectMake(width*(index+1), 0, width, height) animated:YES];
        
        [_pageCtrl setCurrentPage:index+1];
    }
    else{
        [_newsScrollview scrollRectToVisible:CGRectMake(0, 0, width, height) animated:YES];
        [_pageCtrl setCurrentPage:0];
    }
}

- (void)tableViewInit{
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
}

- (void)typeStackviewInit{
    for (int i=0; i<7; i++) {

        UIButton *btn= [[UIButton alloc]init];
        btn.tag=i;
        UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"news%d",i]];
        [btn setImage:img forState:UIControlStateNormal];
        btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
        UIImage *imgSelect=[UIImage imageNamed:[NSString stringWithFormat:@"news%d-1",i]];
        [btn setImage:imgSelect forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_typeStackview addArrangedSubview:btn];
    }
}

- (void)setNewsScrollview{
    CGFloat width=_newsImgView.frame.size.width;
    CGFloat height=_newsImgView.frame.size.height;
    _newsScrollview.contentSize=CGSizeMake(width*10, height);
    _newsScrollview.delegate=self;
    for (int i=0; i<10; i++) {
        newsView *tView;
        if(!tView){
            NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"newsView" owner:nil options:nil];
            for (UIView *view in views)
            {
                if ([view isKindOfClass:[newsView class]])
                {
                    tView =(newsView *)view;
                }
            }
        }
        [tView setFrame:CGRectMake(i*width,0,width,height)];
        [tView setimgWithUrl:_contentsArr[7][i].imageUrl title:_contentsArr[7][i].title];
        
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newsScrollviewClick:)];
        [tView addGestureRecognizer:gesture];
        [_newsScrollview addSubview:tView];
    }
}

- (void)newsScrollviewClick:(UITapGestureRecognizer*)singleTap{
    CGPoint point=[singleTap locationInView:_newsScrollview];
    CGFloat width=_newsScrollview.frame.size.width;
    int index=(int)point.x/width;
    
    NSURL *url=[NSURL URLWithString:_contentsArr[7][index].url];
    if (url.scheme.length==0){
        url=[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",_contentsArr[7][index].url]];
    }
    SFSafariViewControllerConfiguration *configuration;
    configuration.entersReaderIfAvailable=TRUE;
    SFSafariViewController *tView=[[SFSafariViewController alloc]initWithURL:url configuration:configuration];
    tView.delegate = self;
    [self presentViewController:tView animated:YES completion:nil];
    
}

- (void)doGetNewsWithType:(int)type{
    newsReq *req=[[newsReq alloc]initWithaccountID:@"test" lastIndex:-1 count:20 type:@[@(type)]];
    [_dataManager getNews:req];
}

- (void)handleGetNews:(newsRes *)res{
    if(res.status==0){
        if(_isFisrt){
            _isFisrt=NO;
            [_contentsArr[7] addObjectsFromArray:res.results.content];
            [self setNewsScrollview];
            [self setTimer];
            return;
        }
        
        
        int type=res.results.content[0].type;
        int index=(type==10)?type-4:type-3;
        [_contentsArr[index] addObjectsFromArray:res.results.content];
        
        if(type==3){
            _showContents=_contentsArr[index];
            [self typeBtnClick:_typeStackview.arrangedSubviews[0]];
        }
    }
}

- (void)typeBtnClick:(UIButton*)btn{
    for (int i=0; i<7; i++) {
        [_typeStackview.arrangedSubviews[i] setSelected:NO];
        
    }
    [btn setSelected:YES];
    _showContents=_contentsArr[btn.tag];;
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    newsTableViewCell *cell = (newsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"newsTableViewCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"newsTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    [cell setCell:_showContents[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showContents.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    newsPopupViewController *tView=[[newsPopupViewController alloc]initWithNibName:@"newsPopupViewController" bundle:nil];
//    [tView showInVC:self data:_showContents[indexPath.row]];
    
    NSURL *url=[NSURL URLWithString:_showContents[indexPath.row].url];
    if (url.scheme.length==0){
        url=[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",_showContents[indexPath.row].url]];
    }
    
    SFSafariViewControllerConfiguration *configuration;
    configuration.entersReaderIfAvailable=TRUE;
    SFSafariViewController *tView=[[SFSafariViewController alloc]initWithURL:url configuration:configuration];
    tView.delegate = self;
    [self presentViewController:tView animated:YES completion:nil];

    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_newsScrollview) {
        CGFloat screenWidth = scrollView.frame.size.width;
        NSInteger currentPage = ((scrollView.contentOffset.x - screenWidth/2)/screenWidth)+1;
        [_pageCtrl setCurrentPage:currentPage];
    }    
}

- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully{
    if(!didLoadSuccessfully)
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)safariViewController:(SFSafariViewController *)controller initialLoadDidRedirectToURL:(NSURL *)URL API_AVAILABLE(ios(11.0)){
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
