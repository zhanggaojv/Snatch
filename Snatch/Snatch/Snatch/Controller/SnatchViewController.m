//
//  SnatchViewController.m
//  夺你所爱
//
//  Created by Zhanggaoju on 16/9/20.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "SnatchViewController.h"
#import "SnatchCell.h"
#import "HeaderView.h"
#import "SnatchData.h"
#import "SnatchModel.h"
#import "bannerData.h"
#import "silderMode.h"
#import "lotteryModel.h"
#import "SDetailsViewController.h"
#import "AlertView.h"
#import "Alert.h"
#import "AlertLoading.h"
#import <objc/runtime.h>

#import "PopupView.h"
#import "LewPopupViewAnimationSlide.h"
#import "LuckyRecordViewController.h"

#import "JSONStrToDict.h"
#import "WXApiRequestHandler.h"

#import "SnatchRecordViewController.h"

#import "MenuCell.h"
#import "MenuList.h"

#import "CLRollLabel.h"
#import "HDModel.h"
#import "HBLists.h"

#import "CoreJPush.h"


NSString * const KcollectionViewCellID = @"cellID";
NSString * const KReusableHeaderView = @"ReusableView";
NSString * const KReusableFooterView = @"reuseFooter";



@interface SnatchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIApplicationDelegate,CoreJPushProtocol>

@property (nonatomic,strong) HeaderView *headView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UICollectionReusableView *reusableView;
@property (nonatomic,strong) NSMutableArray *announcedData;
@property (nonatomic,strong) NSMutableArray *sArr;
@property (nonatomic,strong) bannerData *banData;

@property (nonatomic,strong) NSMutableArray *hbArr;
@property (nonatomic,strong) NSString *open;
@property (nonatomic,strong) CLRollLabel *rollLabel;

@property (nonatomic) int page;
@property (nonatomic) CGFloat headerHeight;

@property (nonatomic) BOOL kuaijie;

@property (nonatomic,strong)UIButton *scrollTopBtn;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MenuList *menuData;

@property (nonatomic,strong) NSMutableArray *aArr;
@end

@implementation SnatchViewController
//点击Home键退出app，再次进入app会调用此方法
- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    //进入前台时调用此函数
    [_tableView removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    _page = 1;
    [self loadNewData];
    self.navigationItem.hidesBackButton =YES;
    //Home键
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:app];
    
    //[self huodongHttps];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBarButtonItem];
    [self NetworkStatus];
    self.title=@"夺你所爱";
    self.navigationController.title=@"夺宝";
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    [CoreJPush addJPushListener:self];
//    [CoreJPush setTags:[NSSet setWithArray:@[@"movie"]] alias:@"12343242" resBlock:^(BOOL res, NSSet *tags, NSString *alias) {
//        
//        if(res==YES){
//            NSLog(@"设置成功：%@,%@,%@",@(res),tags,alias);
//        }else{
//            NSLog(@"设置失败");
//        }
//    }];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *newver = [userDefault objectForKey:@"newver"];

    if (IFNEWVER) {
    //调用红包接口
   // [self HongbaoNotification];
    //调用快捷登录接口
     BOOL ret = [[[NSUserDefaults standardUserDefaults] objectForKey:@"KUSIJIE"] boolValue];
    if (ret==NO) {
        [self kuaijieLogin];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"KUSIJIE"];
      }
    }

}
-(void)dealloc{
    
    [CoreJPush removeJPushListener:self];
}
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"———————————————ViewController: %@",userInfo);
    
}

-(void)addBarButtonItem{
    UIImage* Limage= [UIImage imageNamed:@"daohanglan"];
    CGRect Lframe= CGRectMake(0, 0, 20, 20);
    UIButton *LsomeButton= [[UIButton alloc] initWithFrame:Lframe];
    [LsomeButton addTarget:self action:@selector(Lback) forControlEvents:UIControlEventTouchUpInside];
    [LsomeButton setBackgroundImage:Limage forState:UIControlStateNormal];
    [LsomeButton setShowsTouchWhenHighlighted:YES];
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:LsomeButton];
    
    UIImage* Rimage= [UIImage imageNamed:@"fenzu"];
    CGRect Rframe= CGRectMake(0, 0, 20, 20);
    UIButton *RsomeButton= [[UIButton alloc] initWithFrame:Rframe];
    [RsomeButton addTarget:self action:@selector(Rback) forControlEvents:UIControlEventTouchUpInside];
    [RsomeButton setBackgroundImage:Rimage forState:UIControlStateNormal];
    [RsomeButton setShowsTouchWhenHighlighted:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RsomeButton];
}
//返回
- (void)Lback {
    if (self.navigationController.view.x==0) {
        [UIView animateWithDuration:.3 animations:^{
            self.navigationController.view.x=150;
            [self addMenu];
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            self.navigationController.view.x=0;
            [_tableView removeFromSuperview];
        }];
    }
}
-(void)Rback{
    NSLog(@"一键加群");
    [self joinGroup:@"581940643" key:@"2823307dac56b4189c5f8af460dd93a9b145cf73a5d1685e28c2a70eceac171a"];
}
- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"581940643",@"2823307dac56b4189c5f8af460dd93a9b145cf73a5d1685e28c2a70eceac171a"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_tableView removeFromSuperview];
    
}
-(void)addMenu{
    _menuData=[[MenuList alloc]init];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 150, SCREEN_HEIGHT-42)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.self.window addSubview:_tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;//防止下沉
}
#pragma mark - tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.menuData.textData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rowsArray=self.menuData.textData[section];
    return rowsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"MCell";
    MenuCell *menuCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!menuCell) {
        menuCell=[[MenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    menuCell.menuImgView.image=IMAGE_NAMED(self.menuData.imageData[indexPath.section][indexPath.row]);
    menuCell.menuLabel.text=self.menuData.textData[indexPath.section][indexPath.row];
    menuCell.layer.masksToBounds=YES;
    menuCell.layer.cornerRadius=1;
    menuCell.layer.borderWidth=1;
    menuCell.layer.borderColor=[UIColor whiteSmoke].CGColor;
    menuCell.backgroundColor=[UIColor whiteColor];
    return menuCell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // /list/index /list/index/id/4 /list/index/id/8 /list/index/id/9 /list/index/id/10 /list/index/id/11 /list/index/id/12 /list/index/id/13
    NSMutableArray *urlArr=[NSMutableArray arrayWithObjects:@"/list/index",@"/list/index/id/4",@"/list/index/id/8",@"/list/index/id/9",@"/list/index/id/10",@"/list/index/id/11",@"/list/index/id/12",@"/list/index/id/13", nil];
        [_tableView removeFromSuperview];
        self.navigationController.view.x=0;
    
        self.hidesBottomBarWhenPushed=YES;
        SnatchRecordViewController *snaVC=[[SnatchRecordViewController alloc]init];
        snaVC.Url=urlArr[indexPath.row];
        [self.navigationController pushViewController:snaVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//设置表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}


-(void)kuaijieLogin{
    PopupView *view = [PopupView defaultPopupView];
    view.parentVC = self;
    
    LewPopupViewAnimationSlide *animation = [[LewPopupViewAnimationSlide alloc]init];
    animation.type = LewPopupViewAnimationSlideTypeBottomBottom;
    [self lew_presentPopupView:view animation:animation dismissed:^{
        NSLog(@"动画结束");}];
    _kuaijie=NO;
    if (_kuaijie==NO) {
        _kuaijie=YES;
    }else{
        PopupView *view = [PopupView defaultPopupView];
        view.parentVC = self;
        
        LewPopupViewAnimationSlide *animation = [[LewPopupViewAnimationSlide alloc]init];
        animation.type = LewPopupViewAnimationSlideTypeBottomBottom;
        [self lew_presentPopupView:view animation:animation dismissed:^{
            NSLog(@"动画结束");
        }];
    }
    _kuaijie=NO;
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
    id AnnJson = [XHNetworkCache cacheJsonWithURL:@"CacheAnn"];
    NSLog(@"缓存数据:%@",AnnJson);
     _aArr = [AnnounceModel mj_objectArrayWithKeyValuesArray:AnnJson];
    
    id BanJson = [XHNetworkCache cacheJsonWithURL:@"CacheBan"];
    NSLog(@"缓存数据:%@",BanJson);
    _banData = [bannerData mj_objectWithKeyValues:BanJson];;
    
    id SnatchJson = [XHNetworkCache cacheJsonWithURL:@"CacheSnatch"];
    NSLog(@"缓存数据:%@",SnatchJson);
    _sArr = [SnatchModel mj_objectArrayWithKeyValuesArray:SnatchJson];
    
    [self addAnnouncedDataCollectionVieWUI];
   
}


/**
 *  发送网络请求，获取数据
 */
- (void)sendHttpRequest{
    if ([GJTokenManager hasAvalibleToken]) {
    self.token=[GJTokenManager accessToken];
    NSLog(@"––––––––––––%@",self.token);
}

    
    NSDictionary *banDic=@{@"code":@"indexPiece"};
    NSData *banDate = [NSJSONSerialization dataWithJSONObject:banDic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *banEncryptDate=[SecurityUtil dataAESdata:banDate];
    NSData *banJsondate=[banEncryptDate dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dataDic=@{@"p":@"1",@"num":@"20"};
    NSDictionary *dic=@{@"code":@"announcedData",@"data":dataDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result) {
        
        NSArray *arr = result[@"data"];
        _aArr = [AnnounceModel mj_objectArrayWithKeyValuesArray:arr];
        [self.collectionView reloadData];
        //(同步)写入/更新缓存数据
        //参数1:JSON数据,参数2:数据请求URL
        BOOL sureCache = [XHNetworkCache saveJsonResponseToCacheFile:arr andURL:@"CacheAnn"];
        if(sureCache)
        {
            NSLog(@"(同步)写入/更新缓存数据 成功");
        }
        else
        {
            NSLog(@"(同步)写入/更新缓存数据 失败");
        }

   
    

    [CKHttpCommunicate createRequest:HTTP_Home WithParam:banJsondate withMethod:POST success:^(id result) {
        
        NSMutableDictionary *banDic = result[@"data"];
        _banData = [bannerData mj_objectWithKeyValues:banDic];
        
        //(同步)写入/更新缓存数据
        //参数1:JSON数据,参数2:数据请求URL
        BOOL sureCache = [XHNetworkCache saveJsonResponseToCacheFile:banDic andURL:@"CacheBan"];
        if(sureCache)
        {
            NSLog(@"(同步)写入/更新缓存数据 成功");
        }
        else
        {
            NSLog(@"(同步)写入/更新缓存数据 失败");
        }

        
//        for (silderMode *silder in _banData.slider) {
//            NSLog(@"ilder.imgUrl：%@",silder.imgUrl);
//        }
//        for (lotteryModel *lottery in _banData.lottery) {
//            NSLog(@"lottery.name：%@",lottery.name);
//        }
        NSDictionary *dataDic=@{@"p":@"1",@"num":@"20"};
        NSDictionary *dic=@{@"code":@"indexData",@"data":dataDic};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        //加密
        NSString *encryptDate=[SecurityUtil dataAESdata:data];
        NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
        
        
        [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result) {
            NSLog(@"_+_+_+_+_+_+_+_+_  %@",result);
            NSArray *arr = result[@"data"];
            
            _sArr = [SnatchModel mj_objectArrayWithKeyValuesArray:arr];
            
            [self addAnnouncedDataCollectionVieWUI];
            [self.collectionView reloadData];
            //(同步)写入/更新缓存数据
            //参数1:JSON数据,参数2:数据请求URL
            BOOL sureCache = [XHNetworkCache saveJsonResponseToCacheFile:arr andURL:@"CacheSnatch"];
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
        
        
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:nil];
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
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    
    [self.view addSubview:self.collectionView];
    
    
    //注册重复使用的cell
    [self.collectionView registerClass:[SnatchCell class] forCellWithReuseIdentifier:KcollectionViewCellID];
    
    //注册重复使用的headerView和footerView
    [self.collectionView registerClass:[HeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KReusableHeaderView];
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
    
    //[self hdUI:_hbArr];

}

/**
 *  下拉刷新最新数据
 */
- (void)loadNewData
{
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"p"] = [NSString stringWithFormat:@"%d",_page];
    mDic[@"num"] = @"20";
    NSDictionary *dic=@{@"code":@"indexData",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jData withMethod:POST success:^(id result) {
        NSArray *arr = result[@"data"];
        NSArray *hArr = [SnatchModel mj_objectArrayWithKeyValuesArray:arr];
        [self.sArr removeAllObjects];
        [self.sArr addObjectsFromArray:hArr];
        [self.collectionView reloadData];
        [_collectionView.mj_header endRefreshing];
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        [_collectionView.mj_header endRefreshing];
    } showHUD:nil];

}
/**
 *  上拉加载更多数据
 */
- (void)loadMoreData
{
    ++_page;
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"p"] = [NSString stringWithFormat:@"%d",self.page];
    mDic[@"num"] = @"20";
    NSDictionary *dic=@{@"code":@"indexData",@"data":mDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptStr=[SecurityUtil dataAESdata:data];
    NSData *jData=[encryptStr dataUsingEncoding:NSUTF8StringEncoding];
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jData withMethod:POST success:^(id result) {
        NSArray *arr = result[@"data"];
        NSMutableArray *pArr = [SnatchModel mj_objectArrayWithKeyValuesArray:arr];
        [self.sArr addObjectsFromArray:pArr];
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
    
    SnatchCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:KcollectionViewCellID forIndexPath:indexPath];
    
    
    SnatchModel *sModel = [_sArr objectAtIndex:indexPath.row];
    cell.sModels = sModel;//传过去的值需要定义不一样的名字，防止set方法出错
    cell.nav=self;
//    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=1;
    cell.layer.borderWidth=1;
    cell.layer.borderColor=[UIColor whiteSmoke].CGColor;
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}


- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
    id obj = [_announcedData objectAtIndex:sourceIndexPath.item];
    [_announcedData removeObject:obj];
    [_announcedData insertObject:obj atIndex:destinationIndexPath.item];
}

//设置headerView和footerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //UICollectionReusableView *reusableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        _headView =[self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KReusableHeaderView forIndexPath:indexPath];
        _headView.bData = _banData;
        _headView.nav =self;
        _headView.aArr = _aArr;
        _headView.open=_open;
        
        _headView.hbStr=_hhh;
    }
    return _headView;
}


#pragma mark - UICollectionViewDelegateFlowLayout
//设置cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((SCREEN_WIDTH)/2.0, (SCREEN_HEIGHT)/3.0+5);
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
    CGSize size = CGSizeMake(0, 400-120);
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
    SDetailsViewController *detailVC=[[SDetailsViewController alloc]init];
    SnatchModel *sModel = [_sArr objectAtIndex:indexPath.row];
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


/**
 *红包通知
 */
-(void)HongbaoNotification{
    if ([GJTokenManager hasAvalibleToken]) {
        self.token=[GJTokenManager accessToken];
    }

    NSString *token=[NSString stringWithFormat:@"%@",self.token];
    NSDictionary *dic=@{@"code":@"showHB"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createTokenRequest:HTTP_Home withToken:token WithParam:jsondata withMethod:POST success:^(id result) {
        NSLog(@"%@",result);
        NSLog(@"%@",result[@"msg"]);
        NSDictionary *data=result[@"data"];
        if ([result[@"status"] integerValue]==0) {
            NSLog(@"没有红包");
        }else if([result[@"status"] integerValue]==1){
            //中奖
            NSString *title=data[@"title"];
            NSLog(@"%@",title);
            [self hongbaoView:title];
        
        }else if([result[@"status"] integerValue]==2){
            //充值送
            NSString *resource=data[@"resource"];
            NSString *indexFirst=@"indexFirst";
            NSLog(@"———resource=%@",resource);

            if ([resource isEqualToString:indexFirst]) {
                [self CZSongView];
            }

        }
        
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:nil];
    
}
-(void)hongbaoView:(NSString *)title{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5*4, SCREEN_HEIGHT/5*4)];
    _contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:_contentView.bounds];
    imageV.image=[UIImage imageNamed:@"ZJ"];
    [_contentView addSubview:imageV];
    
    UILabel *tipLb=[[UILabel alloc]initWithFrame:CGRectMake((_contentView.width-200)/2, SCREEN_HEIGHT/5*2+50, 200, 30)];
    tipLb.numberOfLines=2;
    [tipLb setTextAlignment:NSTextAlignmentCenter];
    tipLb.text=@"夺你所爱恭喜您获得";
    tipLb.textColor=[UIColor whiteColor];
    tipLb.alpha=.8;
    tipLb.font=[UIFont systemFontOfSize:20 weight:8];
    [_contentView addSubview:tipLb];
    
    UILabel *titleLb=[[UILabel alloc]initWithFrame:CGRectMake((_contentView.width-200)/2, SCREEN_HEIGHT/5*2+80, 200, 60)];
    titleLb.numberOfLines=2;
    [titleLb setTextAlignment:NSTextAlignmentCenter];
    titleLb.text=title;
    titleLb.textColor=[UIColor redColor];
    titleLb.alpha=.8;
    titleLb.font=[UIFont systemFontOfSize:20 weight:7];
    [_contentView addSubview:titleLb];
    
    
    
    UIButton *chakanBtn=[[UIButton alloc]initWithFrame:CGRectMake((_contentView.width-200)/2, SCREEN_HEIGHT/5*3, 200, 100)];
    [chakanBtn addTarget:self action:@selector(GotoKJ) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:chakanBtn];
    
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:YES];

}
-(void)GotoKJ{
    [[HWPopTool sharedInstance] closeWithBlcok:^{
        self.hidesBottomBarWhenPushed=YES;
        LuckyRecordViewController *luck=[LuckyRecordViewController alloc];
        [self.navigationController pushViewController:luck animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }];
}
-(void)CZSongView{
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5*4, SCREEN_HEIGHT/5*4)];
    _contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:_contentView.bounds];
    imageV.image=[UIImage imageNamed:@"CZS"];
    [_contentView addSubview:imageV];
    
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:YES];
    
    int high=60;
    for (int i=0; i<5; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0,300+i*(high+1), imageV.bounds.size.width, high)];
        btn.backgroundColor=[UIColor clearColor];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"cz0%d",i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(CZAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        [_contentView addSubview:btn];
    }
 
}

-(void)CZAction:(UIButton*)btn{
    if (btn.tag==0) {
         [[HWPopTool sharedInstance] closeWithBlcok:^{
            //NSString *url=@"/pay/pay_weixin_app/price/100/pid/0/hb/1";
             NSString *token=[NSString stringWithFormat:@"%@",self.token];
             NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
             mDic[@"price"] = @"100";
             mDic[@"pid"] = @"0";
             mDic[@"hb"] = @"1";
             
             [CKHttpCommunicate createTokenRequest:HTTP_WX withToken:token WithParam:mDic withMethod:POST success:^(id result) {
                 NSMutableDictionary *data = result[@"data"];
//                 [self bizPay:data];
                 [self SPay:data];
             } failure:^(NSError *erro) {
                 NSLog(@"请求错误");
             } showHUD:nil];
         }];
    }else if (btn.tag==1) {
        [[HWPopTool sharedInstance] closeWithBlcok:^{
            NSString *token=[NSString stringWithFormat:@"%@",self.token];
            //NSString *url=@"/pay/pay_weixin_app/price/50/pid/0/hb/1";
            NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
            mDic[@"price"] = @"50";
            mDic[@"pid"] = @"0";
            mDic[@"hb"] = @"1";
        
            [CKHttpCommunicate createTokenRequest:HTTP_WX withToken:token WithParam:mDic withMethod:POST success:^(id result) {
                NSLog(@"$$$$$$$$$______%@",result);
                NSMutableDictionary *data = result[@"data"];
//                [self bizPay:data];
                [self SPay:data];
            } failure:^(NSError *erro) {
                NSLog(@"请求错误");
                [self.collectionView.mj_footer endRefreshing];
            } showHUD:nil];
         
            
        }];
    }else if (btn.tag==2) {
        [[HWPopTool sharedInstance] closeWithBlcok:^{
          
           // NSString *url=@"/pay/pay_weixin_app/price/10/pid/0/hb/1";
            NSString *token=[NSString stringWithFormat:@"%@",self.token];
            NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
            mDic[@"price"] = @"10";
            mDic[@"pid"] = @"0";
            mDic[@"hb"] = @"1";
            
            [CKHttpCommunicate createTokenRequest:HTTP_WX withToken:token WithParam:mDic withMethod:POST success:^(id result) {
                NSLog(@"$$$$$$$$$______%@",result);
                NSMutableDictionary *data = result[@"data"];
           // [self bizPay:data];
                [self SPay:data];
            } failure:^(NSError *erro) {
                NSLog(@"请求错误");
            } showHUD:nil];
           
            
        }];
    }else if (btn.tag==3) {
        [[HWPopTool sharedInstance] closeWithBlcok:^{
           
           // NSString *url=@"/pay/pay_weixin_app/price/1/pid/0/hb/1";
            NSString *token=[NSString stringWithFormat:@"%@",self.token];
            NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
            mDic[@"price"] = @"1";
            mDic[@"pid"] = @"0";
            mDic[@"hb"] = @"1";
            
            [CKHttpCommunicate createTokenRequest:HTTP_WX withToken:token WithParam:mDic withMethod:POST success:^(id result) {
                NSLog(@"$$$$$$$$$______%@",result);
                NSMutableDictionary *data = result[@"data"];
//                [self bizPay:data];
                [self SPay:data];
            } failure:^(NSError *erro) {
                NSLog(@"请求错误");
            } showHUD:nil];
          
            
        }];
    }
}
-(void)SPay:(NSMutableDictionary *)wxData{
    // 调起SPaySDK支付
    [[SPayClient sharedInstance] pay:self
                              amount:wxData[@"key"]
                   spayTokenIDString:wxData[@"token_id"]
                   payServicesString:@"pay.weixin.app"
                              finish:^(SPayClientPayStateModel *payStateModel,
                                       SPayClientPaySuccessDetailModel *paySuccessDetailModel) {
                                  
                                  //更新订单号
                                  //self.out_trade_noText.text = wxData[@"sign"];
                                  
                                  
                                  if (payStateModel.payState == SPayClientConstEnumPaySuccess) {
                                      
                                      NSLog(@"支付成功");
                                      NSLog(@"支付订单详情-->>\n%@",[paySuccessDetailModel description]);
                                  }else{
                                      NSLog(@"支付失败，错误号:%d",payStateModel.payState);
                                  }
                                  
                              }];
    
}

- (void)bizPay:(NSMutableDictionary *)dict {
    NSString *res = [WXApiRequestHandler jumpToBizPay:dict];
    

    if( ![@"" isEqual:res] ){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }else{
         [FormValidator showAlertWithStr:@"恭喜您，充值成功!"];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
