//
//  BillViewController.m
//  夺你所爱
//
//  Created by Zhanggaoju on 16/9/20.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "BillViewController.h"
#import "BillCell.h"
#import "BillData.h"
#import "BillModel.h"
#import "BDetailsViewController.h"
#import "BillUserViewController.h"
#import "XWPublishController.h"

@interface BillViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *sArr;

@property (nonatomic) int page;

@property (nonatomic,strong)UIButton *scrollTopBtn;

@end

@implementation BillViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self addBarButtonItem];
   // [self sendHttpRequest];
    [self NetworkStatus];
    _page = 1;
    
}
-(void)NetworkStatus{
    
    Reachability *reachability=[Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
            
        case NotReachable:
            [self loadCacheData];
           
            break;
        case ReachableViaWiFi:
            [self sendHttpRequest];
            break;
        case ReachableViaWWAN:
            [self sendHttpRequest];
            break;
    }
}
-(void)loadCacheData{
    //获取缓存数据
    //参数:数据请求URL
    id cacheJson = [XHNetworkCache cacheJsonWithURL:@"BillCache"];
    NSLog(@"缓存数据:%@",cacheJson);
    _sArr = [BillModel mj_objectArrayWithKeyValuesArray:cacheJson];
     [self addBillTableVIewUI];
}

/**
 *  发送网络请求，获取数据
 */
- (void)sendHttpRequest
{
    NSDictionary *dataDic=@{@"p":@"1"};
    NSDictionary *dic=@{@"code":@"sharedList",@"data":dataDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result) {
        NSArray *arr = result[@"data"];
        NSLog(@"%@",result);
        _sArr = [BillModel mj_objectArrayWithKeyValuesArray:arr];
        NSLog(@"___________sArr;%@",_sArr);
        [self addBillTableVIewUI];
        for (BillModel *sModel in _sArr) {
            NSLog(@"%@",sModel.name);
        }
        
        //(同步)写入/更新缓存数据
        //参数1:JSON数据,参数2:数据请求URL
        BOOL sureCache = [XHNetworkCache saveJsonResponseToCacheFile:arr andURL:@"BillCache"];
        if(sureCache)
        {
            NSLog(@"(同步)写入/更新缓存数据 成功");
        }
        else
        {
            NSLog(@"(同步)写入/更新缓存数据 失败");
        }

    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:self.view];
}
/**
 *  布局UI界面
 */
-(void)addBillTableVIewUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setShowsVerticalScrollIndicator:YES];
    [_tableView setBackgroundColor:self.view.backgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = YES;
    _tableView.delaysContentTouches = NO;
    
    [self.view addSubview:_tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;//防止下沉
    
    //添加下拉刷新
    self.tableView.mj_header = [GJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    //添加上拉加载更多
    self.tableView.mj_footer = [GJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //创建回到顶部按钮
    [self initializeButtonWithFrame:CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-150,50, 50) title:nil action:@selector(scrollToTop:)];
    _scrollTopBtn.hidden=YES;
    [self.view bringSubviewToFront:_scrollTopBtn];
    
    
}
/**
 *  下拉刷新最新数据
 */
- (void)loadNewData
{
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
    mDic[@"p"] = [NSString stringWithFormat:@"%d",_page];
    NSDictionary *dic=@{@"code":@"sharedList",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result) {
        NSArray *arr = result[@"data"];
        NSArray *newArr = [BillModel mj_objectArrayWithKeyValuesArray:arr];
        [self.sArr removeAllObjects];
        [self.sArr addObjectsFromArray:newArr];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        [self.tableView.mj_header endRefreshing];
    } showHUD:nil];
    
}
/**
 *  上拉加载更多数据
 */
- (void)loadMoreData
{
    ++_page;
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
    mDic[@"p"] = [NSString stringWithFormat:@"%d",_page];
    NSDictionary *dic=@{@"code":@"sharedList",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result) {
        NSArray *arr = result[@"data"];
        NSArray *oldArr = [BillModel mj_objectArrayWithKeyValuesArray:arr];
        [self.sArr addObjectsFromArray:oldArr];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        [self.tableView.mj_footer endRefreshing];
    } showHUD:nil];
    NSLog(@"page:第%d页",_page);
}
#pragma mark - tableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"BillCell";
    BillCell *activitisCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!activitisCell) {
        activitisCell=[[BillCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        activitisCell.layer.masksToBounds=YES;
        activitisCell.layer.cornerRadius=12;
        activitisCell.layer.borderWidth=3;
        activitisCell.layer.borderColor=[UIColor whiteSmoke].CGColor;
        activitisCell.backgroundColor=[UIColor whiteColor];
        activitisCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    BillModel *sModel =[_sArr objectAtIndex:indexPath.section];
    activitisCell.bModel = sModel;
    activitisCell.nav=self;
    return activitisCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 285;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.01f];
    self.hidesBottomBarWhenPushed=YES;
    BDetailsViewController *detailsVC=[[BDetailsViewController alloc]init];
    BillModel *sModel = [_sArr objectAtIndex:indexPath.section];
    detailsVC.detailsUrl = sModel.url;
    [self.navigationController pushViewController:detailsVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  _sArr.count;
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    view.backgroundColor = [UIColor clearColor];
//    UIView *colorview=[[UIView alloc] initWithFrame:CGRectMake(13, 0, SCREEN_WIDTH-26, 3)];
//    if (section>0) {
//        colorview.backgroundColor=[UIColor snowColor];
//        colorview.alpha=.5;
//        colorview.layer.masksToBounds=YES;
//        colorview.layer.cornerRadius=1;
//    }
//    [view addSubview:colorview];
    return view;
}

//点击后，过段时间cell自动取消选中
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    
}
-(void)addBarButtonItem{
    
    self.navigationItem.hidesBackButton=YES;
    
}
//返回
- (void)Lback {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)Rback {
    
    XWPublishController *publishVC = [[XWPublishController alloc] init];
    
    
    
    [self presentViewController:publishVC animated:YES completion:nil];
    
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.bounds.origin.y>SCREEN_HEIGHT*6) {
        
        _scrollTopBtn.hidden=NO;
    }else{
        _scrollTopBtn.hidden=YES;
    }
}

#pragma mask  - 滚动到顶部
- (void)initializeButtonWithFrame:(CGRect)frame title:(NSString*)title action:(SEL)aSEL{
    _scrollTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _scrollTopBtn.backgroundColor = [UIColor grayColor];
    _scrollTopBtn.frame = frame;
    [_scrollTopBtn setImage:[UIImage imageNamed:@"topBtn"] forState:UIControlStateNormal];
    _scrollTopBtn.layer.masksToBounds=YES;
    _scrollTopBtn.layer.cornerRadius=25;
    [_scrollTopBtn setTitle:title forState:0];
    [_scrollTopBtn addTarget:self action:aSEL forControlEvents:UIControlEventTouchUpInside];
    _scrollTopBtn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_scrollTopBtn];
}
- (void)scrollToTop:(UIButton *)btn{
    NSLog(@"滚到顶部");
    _scrollTopBtn.hidden=YES;
    [_tableView scrollToRow:0 inSection:0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
