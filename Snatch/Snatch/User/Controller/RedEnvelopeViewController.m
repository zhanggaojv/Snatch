//
//  AnnouncementViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/7.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "RedEnvelopeViewController.h"
#import "redCell.h"
#import "redModel.h"
#import "PayViewController.h"

@interface RedEnvelopeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sArr;

@end

@implementation RedEnvelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBarButtonItem];
    [self sendHttpRequest];
    self.title=@"可用红包";
}
-(void)addBarButtonItem{
    UIImage* Limage= [UIImage imageNamed:@"liftBtn"];
    CGRect Lframe= CGRectMake(0, 0, 20, 20);
    UIButton *LsomeButton= [[UIButton alloc] initWithFrame:Lframe];
    [LsomeButton addTarget:self action:@selector(Lback) forControlEvents:UIControlEventTouchUpInside];
    [LsomeButton setBackgroundImage:Limage forState:UIControlStateNormal];
    [LsomeButton setShowsTouchWhenHighlighted:YES];
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:LsomeButton];
    
    UIImage* Rimage= [UIImage imageNamed:@"rightBtn"];
    CGRect Rframe= CGRectMake(0, 0, 20, 20);
    UIButton *RsomeButton= [[UIButton alloc] initWithFrame:Rframe];
    [RsomeButton addTarget:self action:@selector(Rback) forControlEvents:UIControlEventTouchUpInside];
    [RsomeButton setBackgroundImage:Rimage forState:UIControlStateNormal];
    [RsomeButton setShowsTouchWhenHighlighted:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RsomeButton];
    
}
//返回
- (void)Lback {
    
        [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)Rback {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

/**
 *  发送网络请求，获取数据
 */
- (void)sendHttpRequest
{
    NSDictionary *dataDic=@{@"yfprice":_yfprice};
    NSDictionary *dic=@{@"code":@"usableHB",@"data":dataDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result) {
        NSLog(@"_________****  %@",result);
        NSDictionary *dic = result[@"data"];
        NSArray *list=dic[@"list"];
        _sArr = [redModel mj_objectArrayWithKeyValuesArray:list];
        [self addActivitisTableVIewUI];
        
                for (redModel *sModel in _sArr) {
                    NSLog(@"+_+_+_+_+_________hahahahahah：%@",sModel.ID);
                }
        
    } failure:^(NSError *erro) {
        NSLog(@"请求错误");
        
    } showHUD:nil];
    
}
-(void)addActivitisTableVIewUI{
    self.view.backgroundColor=[UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+30, SCREEN_WIDTH, SCREEN_HEIGHT-64-30) style:UITableViewStylePlain];
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
    
    [self addHeaderView];
}
-(void)addHeaderView{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor lightSeaGreen];
    UILabel *l=[[UILabel alloc]initWithFrame:CGRectMake(5,0, SCREEN_WIDTH, 30)];
    l.text=@"红包说明：可用红包为小于应付金额的红包。";
    l.textAlignment=NSTextAlignmentLeft;
    l.textColor=[UIColor whiteColor];
    l.font=[UIFont systemFontOfSize:13];
    [view addSubview:l];
   // _tableView.tableHeaderView=view;
    [self.view addSubview:view];
}

/**
 *  下拉刷新最新数据
 */
- (void)loadNewData
{
    NSDictionary *dataDic=@{@"yfprice":_yfprice};
    NSDictionary *dic=@{@"code":@"usableHB",@"data":dataDic};

    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //加密
    NSString *encryptDate=[SecurityUtil dataAESdata:data];
    NSData *jsondata=[encryptDate dataUsingEncoding:NSUTF8StringEncoding];
    [CKHttpCommunicate createRequest:HTTP_Home WithParam:jsondata withMethod:POST success:^(id result) {
        NSLog(@"_________****  %@",result);
        NSDictionary *dic = result[@"data"];
        NSArray *list=dic[@"list"];
        NSArray *newArr = [redModel mj_objectArrayWithKeyValuesArray:list];
        [self.sArr removeAllObjects];
        [self.sArr addObjectsFromArray:newArr];
        
        for (redModel *sModel in _sArr) {
            NSLog(@"+_+_+_+_+_________hahahahahah：%@",sModel.ID);
        }
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
    static NSString *cellIdentifier=@"redCell";
    redCell *activitisCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!activitisCell) {
        activitisCell=[[redCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        activitisCell.layer.cornerRadius=2;
        activitisCell.layer.borderWidth=2;
        activitisCell.layer.borderColor=[UIColor whiteSmoke].CGColor;
        activitisCell.backgroundColor=[UIColor groupTableViewBackgroundColor];
        activitisCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    activitisCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    activitisCell.layer.masksToBounds =YES;
    //    activitisCell.layer.cornerRadius=5;
    redModel *sModel =[_sArr objectAtIndex:indexPath.section];
    activitisCell.aModels =sModel;
    
    return activitisCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1f];
    redModel *sModel =[_sArr objectAtIndex:indexPath.section];
    [self.money_Delegate setValue:sModel.money];
    [self.hbid_Delegate hbidsetValue:sModel.ID];
    [self.navigationController popViewControllerAnimated:YES];
}

//点击后，过段时间cell自动取消选中
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
////section头部视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    view.backgroundColor = [UIColor lightPink];
//    UILabel *l=[[UILabel alloc]initWithFrame:view.bounds];
//    l.text=@"红包说明：可用红包未小于应付金额的红包。";
//    l.textAlignment=NSTextAlignmentLeft;
//    l.textColor=[UIColor lightTextColor];
//    l.font=[UIFont systemFontOfSize:13];
//    [view addSubview:l];
//    return view;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
