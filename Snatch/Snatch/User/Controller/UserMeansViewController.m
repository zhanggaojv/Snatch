//
//  UserMeansViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/12/17.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "UserMeansViewController.h"
#import "MeansCell.h"
#import "MeansMode.h"

#import "UIViewController+XHPhoto.h"
@interface UserMeansViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) MeansMode *menuData;

@end

@implementation UserMeansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBarButtonItem];
    [self addUserTableVIewUI];
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
 *  布局UI界面
 */
-(void)addUserTableVIewUI{
    self.title=@"个人资料";
    self.view.backgroundColor=[UIColor whiteColor];
    _menuData=[[MeansMode alloc]init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 200);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setShowsVerticalScrollIndicator:YES];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   // _tableView.scrollEnabled = NO; // 设置为不可滚动
    [self.view addSubview:_tableView];
    _tableView.delaysContentTouches = NO;
    _tableView.bounces=YES;
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
    static NSString *cellIdentifier=@"SettingCell";
    MeansCell *userCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!userCell) {
        userCell=[[MeansCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0: {
                _pic=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 3, 50, 50)];
                _pic.layer.masksToBounds=YES;
                _pic.layer.cornerRadius=25;
                _pic.backgroundColor=[UIColor orangeRed];
                [userCell addSubview:_pic];
                [_pic setImageWithURL:_headimgUrl placeholder:[UIImage imageNamed:@""]];
               
                
            }
                break;
            case 1: {
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 13, 100, 30)];
                label.textColor=[UIColor lightSeaGreen];
                label.textAlignment=NSTextAlignmentRight;
                label.font=[UIFont fontWithName:@"Helvetica" size:15.0];
                [userCell addSubview:label];
                 label.text=_nickname;
            }
                break;
            case 2: {
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 13, 100, 30)];
                label.textColor=[UIColor lightSeaGreen];
                label.textAlignment=NSTextAlignmentRight;
                label.font=[UIFont fontWithName:@"Helvetica" size:15.0];
                [userCell addSubview:label];
            }
                 break;
            case 3: {
                UIImageView *pic=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 8, 40, 40)];
                pic.backgroundColor=[UIColor lightSeaGreen];
                [userCell addSubview:pic];
            }
                break;
            case 4: {
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 13, 100, 30)];
                label.textColor=[UIColor lightSeaGreen];
                label.textAlignment=NSTextAlignmentRight;
                label.font=[UIFont fontWithName:@"Helvetica" size:15.0];
                [userCell addSubview:label];
                
            }
                break;
            case 5: {
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 13, 100, 30)];
                label.textColor=[UIColor lightSeaGreen];
                label.textAlignment=NSTextAlignmentRight;
                label.font=[UIFont fontWithName:@"Helvetica" size:15.0];
                [userCell addSubview:label];
            }

                break;
            default:
                break;
        }
    }
    userCell.selectionStyle = UITableViewCellSelectionStyleNone;

    userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    userCell.titile.text=self.menuData.textData[indexPath.section][indexPath.row];
    userCell.layer.masksToBounds=YES;
    userCell.layer.cornerRadius=1;
    userCell.layer.borderWidth=1;
    userCell.layer.borderColor=[UIColor whiteSmoke].CGColor;
    userCell.backgroundColor=[UIColor whiteColor];
    
    return userCell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.01f];

    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0: {
                /*
                 edit:照片需要裁剪:传YES,不需要裁剪传NO(默认NO)
                 */
                [self showCanEdit:YES photo:^(UIImage *photo) {
                    _avatar = photo;
                    NSMutableArray *avatarArr=[NSMutableArray array];
                    [avatarArr addObject:_avatar];
                    //图片转成data
                    NSData *picData = UIImageJPEGRepresentation(_avatar, 0.5);
                    
                    NSMutableDictionary *Exparams = [[NSMutableDictionary alloc]init];
                    //放到数组里边
                    [Exparams addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:picData,@"file", nil]];
                    
                    self.token=[GJTokenManager accessToken];
                    NSString *token=[NSString stringWithFormat:@"%@",self.token];
                    NSDictionary *dic=@{@"ht":@"1"};
                    [CKHttpCommunicate createRequest:HTTP_Image withToken:token WithParam:dic withExParam:Exparams withMethod:POST success:^(id result) {
                        NSLog(@"%@",result);
                        NSLog(@"%@",result[@"msg"]);
                        _pic.image=_avatar;
                        [self.tableView rectForSection:0];
                    } uploadFileProgress:^(NSProgress *uploadProgress) {
                        NSLog(@"uploadProgress:%@",uploadProgress);
                    } failure:^(NSError *erro) {
                        NSLog(@"上传失败……");
                    }];
            
                }];
                
                
            }
                break;
            case 1: {
              
            }
                break;
            case 2: {
           
            }
                break;
            case 3: {
                
            }
                break;
            case 4: {
                
            }
                break;
            case 5: {
               
            }
                break;
            default:
                break;
        }
    }
    
}
//点击后，过段时间cell自动取消选中
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

//设置表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
