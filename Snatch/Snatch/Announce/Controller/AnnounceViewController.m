//
//  AnnounceViewController.m
//  夺你所爱
//
//  Created by Zhanggaoju on 16/9/20.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "AnnounceViewController.h"
#import "AnnounceCell.h"
#import "WinnersCell.h"
#import "AnnounceData.h"
#import "AnnounceModel.h"
#import "CKHttpCommunicate.h"
#import "ADetailsViewController.h"

#import "PayViewController.h"

NSString *const Ann_ID = @"cellID_Ann";
NSString *const Win_ID = @"cellID_Win";

@interface AnnounceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *announcedData;

@property (nonatomic,strong) NSMutableArray *sArr;

@property (nonatomic) int page;
@property (nonatomic) CGFloat headerHeight;

@property (nonatomic,strong)UIButton *scrollTopBtn;

@end

@implementation AnnounceViewController

-(void)viewWillAppear:(BOOL)animated{
     _page = 1;
    //发起网络请求
    [self loadNewData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self NetworkStatus];
    // Do any additional setup after loading the view.
    
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
    id cacheJson = [XHNetworkCache cacheJsonWithURL:@"AnnCache"];
    NSLog(@"缓存数据:%@",cacheJson);
    _sArr = [AnnounceModel mj_objectArrayWithKeyValuesArray:cacheJson];
    [self addAnnouncedDataCollectionVieWUI];
}


/**
 *  发送网络请求，获取数据
 */
- (void)sendHttpRequest
{
    NSDictionary *dataDic=@{@"p":@"1",@"num":@"20"};
    NSDictionary *dic=@{@"code":@"announcedData",@"data":dataDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result) {
        NSLog(@"%@",result);
        NSArray *arr = result[@"data"];
        _sArr = [AnnounceModel mj_objectArrayWithKeyValuesArray:arr];
        [self addAnnouncedDataCollectionVieWUI];
        [self.collectionView reloadData];
        
        //(同步)写入/更新缓存数据
        //参数1:JSON数据,参数2:数据请求URL
        BOOL sureCache = [XHNetworkCache saveJsonResponseToCacheFile:arr andURL:@"AnnCache"];
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
-(void)addAnnouncedDataCollectionVieWUI{
    //创建布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, WSSCREENWIDTH, WSSCREENHEIGHT - 64) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView];
    
    
    //注册Ann重复使用的cell
    [self.collectionView registerClass:[AnnounceCell class] forCellWithReuseIdentifier:Ann_ID];
    
    //注册Win重复使用的cell
    [self.collectionView registerClass:[WinnersCell class] forCellWithReuseIdentifier:Win_ID];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//防止下沉
    
    //添加下拉刷新
    self.collectionView.mj_header = [GJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    //添加上拉加载更多
    self.collectionView.mj_footer = [GJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _announcedData = [NSMutableArray array];
    
    //创建回到顶部按钮
    [self initializeButtonWithFrame:CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-150,50, 50) title:nil action:@selector(scrollToTop:)];
    _scrollTopBtn.hidden=YES;
    [self.view bringSubviewToFront:_scrollTopBtn];

   }

/**
 *  下拉刷新最新数据
 */
- (void)loadNewData
{   if(_page<1){
    _page=1;
    }
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"p"] = [NSString stringWithFormat:@"%d",_page];
    mDic[@"num"] = @"20";
    NSDictionary *dic=@{@"code":@"announcedData",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jData withMethod:POST success:^(id result) {
        NSArray *arr = result[@"data"];
        NSArray *newArr = [AnnounceModel mj_objectArrayWithKeyValuesArray:arr];
        [self.sArr removeAllObjects];
        [self.sArr addObjectsFromArray:newArr];
        [self.collectionView reloadData];
        [_collectionView.mj_header endRefreshing];
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        [self.collectionView.mj_header endRefreshing];
    } showHUD:nil];

}

/**
 *  上拉加载更多数据
 */
- (void)loadMoreData
{
    ++_page;
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"p"] = [NSString stringWithFormat:@"%d",_page];
    mDic[@"num"] = @"20";
    NSDictionary *dic=@{@"code":@"announcedData",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jData withMethod:POST success:^(id result) {
        NSArray *arr = result[@"data"];
        NSArray *oldArr = [AnnounceModel mj_objectArrayWithKeyValuesArray:arr];
        NSLog(@"_____%@",result);
        [self.sArr addObjectsFromArray:oldArr];
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
            [self.collectionView.mj_footer endRefreshing];
     } showHUD:nil];
    NSLog(@"page:第%d页",_page);

}

#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _sArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timeStopAction) name:@"timeStop" object:nil];
    UICollectionViewCell *cell=nil;
    AnnounceModel *sModel = [_sArr objectAtIndex:indexPath.row];
    if ([sModel.state intValue]==1) {
         AnnounceCell *Acell = [self.collectionView dequeueReusableCellWithReuseIdentifier:Ann_ID forIndexPath:indexPath];
        Acell.aModels = sModel;
        cell=Acell;
    }else{
         WinnersCell *Wcell = [self.collectionView dequeueReusableCellWithReuseIdentifier:Win_ID forIndexPath:indexPath];
        Wcell.wModels=sModel;
        cell=Wcell;
    }
   
    //cell.backgroundColor = [UIColor whiteColor];
    
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=1;
    cell.layer.borderWidth=1;
    cell.layer.borderColor=[UIColor whiteSmoke].CGColor;
    cell.backgroundColor=[UIColor whiteColor];

    return cell;
}
-(void)timeStopAction{
    NSLog(@"真的吗？？？");
   

}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
    id obj = [_announcedData objectAtIndex:sourceIndexPath.item];
    [_announcedData removeObject:obj];
    [_announcedData insertObject:obj atIndex:destinationIndexPath.item];
}


#pragma mark - UICollectionViewDelegateFlowLayout
//设置cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((SCREEN_WIDTH)/2.0, SCREEN_HEIGHT/3.0+40);
    return size;
}

//设置cell与边缘的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    return inset;
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//设置header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeMake(0, 0);
    return size;
}

//设置footer高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size = CGSizeMake(0, 0);
    return size;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击section%ld的第%ld个cell",indexPath.section,indexPath.row);
    self.hidesBottomBarWhenPushed=YES;
    ADetailsViewController *detailVC=[[ADetailsViewController alloc]init];
    AnnounceModel *sModel = [_sArr objectAtIndex:indexPath.row];
    detailVC.detailurl =sModel.url;
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
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
    NSIndexPath *topRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [_collectionView scrollToItemAtIndexPath:topRow atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
