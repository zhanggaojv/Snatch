//
//  ActivitiesViewController.m
//  夺你所爱
//
//  Created by Zhanggaoju on 16/9/20.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "ActivitisCell.h"
#import "ActiviesModel.h"
#import "InviteViewController.h"



@interface ActivitiesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sArr;

@end

@implementation ActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self NetworkStatus];
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
    id cacheJson = [XHNetworkCache cacheJsonWithURL:@"ActivitisCache"];
    NSLog(@"缓存数据:%@",cacheJson);
    _sArr = [ActiviesModel mj_objectArrayWithKeyValuesArray:cacheJson];
    [self addActivitisTableVIewUI];
}

/**
 *  发送网络请求，获取数据
 */
- (void)sendHttpRequest
{
    NSDictionary *dic=@{@"code":@"activityList"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result) {
        NSLog(@"_________****  %@",result);
        NSArray *arr = result[@"data"];
        _sArr = [ActiviesModel mj_objectArrayWithKeyValuesArray:arr];
        [self addActivitisTableVIewUI];
        
        //        for (ActiviesModel *sModel in _sArr) {
        //            //NSLog(@"+_+_+_+_+_________hahahahahah：%@",sModel.link);
        //        }
        
        //(同步)写入/更新缓存数据
        //参数1:JSON数据,参数2:数据请求URL
        BOOL sureCache = [XHNetworkCache saveJsonResponseToCacheFile:arr andURL:@"ActivitisCache"];
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
        
    } showHUD:nil];
   
}
-(void)addActivitisTableVIewUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setShowsVerticalScrollIndicator:YES];
    [_tableView setBackgroundColor:self.view.backgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     _tableView.scrollEnabled = YES;
    [self.view addSubview:_tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;//防止下沉
    
    //添加下拉刷新
    self.tableView.mj_header = [GJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
}

/**
 *  下拉刷新最新数据
 */
- (void)loadNewData
{
    NSDictionary *dic=@{@"code":@"activityList"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result) {
        
        NSArray *arr = result[@"data"];
        NSArray *newArr = [ActiviesModel mj_objectArrayWithKeyValuesArray:arr];
        [self.sArr removeAllObjects];
        [self.sArr addObjectsFromArray:newArr];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:nil];
    
}

#pragma mark - tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  _sArr.count;
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;//section头部高度
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"ActivitisCell";
    ActivitisCell *activitisCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!activitisCell) {
        activitisCell=[[ActivitisCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        activitisCell.layer.cornerRadius=2;
        activitisCell.layer.borderWidth=2;
        activitisCell.layer.borderColor=[UIColor whiteSmoke].CGColor;
        activitisCell.backgroundColor=[UIColor whiteColor];
        activitisCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    activitisCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    activitisCell.layer.masksToBounds =YES;
//    activitisCell.layer.cornerRadius=5;
    ActiviesModel *sModel =[_sArr objectAtIndex:indexPath.section];
    activitisCell.aModels =sModel;
    
    return activitisCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1f];
    self.hidesBottomBarWhenPushed=YES;
    InviteViewController *activiesVC=[[InviteViewController alloc]init];
    
    ActiviesModel *sModel=[_sArr objectAtIndex:indexPath.section];
    
    activiesVC.inviteurl = sModel.link;
    
    [self.navigationController pushViewController:activiesVC animated:YES];
     self.hidesBottomBarWhenPushed=NO;
}

//点击后，过段时间cell自动取消选中
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
