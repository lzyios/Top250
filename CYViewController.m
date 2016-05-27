//
//  CYViewController.m
//  Top250
//
//  Created by lcy on 15/9/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYViewController.h"
#import "AFNetworking.h"
#import "CYMovie.h"
#import "CYJSONMovieModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "CYDataBase.h"

//0 - 19 20 - 40
/*
    start = 0
    count = 20
    start+=20
 */
#define MOVIE_URL @"http://api.douban.com/v2/movie/top250?apikey=02d830457f4a8f6d088890d07ddfae47&start=%ld&count=20"
@interface CYViewController () <UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic) NSInteger offset;
@property (nonatomic) BOOL isDown;

@property (nonatomic,strong) MJRefreshHeaderView *headerView;
@property (nonatomic,strong) MJRefreshFooterView *footerView;

@end

@implementation CYViewController

-(NSMutableArray *)dataSource{
    if(_dataSource == nil)
    {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 375, 667 - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        self.headerView = [[MJRefreshHeaderView alloc] initWithScrollView:_tableView];
        self.footerView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
        
        self.headerView.delegate = self;
        self.footerView.delegate = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    
    return _tableView;
}

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if(refreshView == self.headerView)
    {
        self.offset = 0;
        _isDown = YES;
    }
    else if(refreshView == self.footerView)
    {
        self.offset += 20;
        _isDown = NO;
    }
    
    [self startRequestData];
    
    //延时执行结束动画的方法
    [refreshView performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0f];
}

-(void)dealloc
{
    //释放 header和 footer
    [self.headerView free];
    [self.footerView free];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    CYJSONMovieModel *movie = self.dataSource[indexPath.row];
    cell.textLabel.text = movie.abc;
    
    
    //sd_setImageWithURL 自动缓存图片
    //key movie.image  ---->   image
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:movie.image] placeholderImage:[UIImage imageNamed:@"1"]];
    
    return cell;
}

-(void)startRequestData
{
    
    AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
    
    man.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *urlStr = [NSString stringWithFormat:MOVIE_URL,self.offset];
    [man GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //删除数据
        if(_isDown == YES)
        {
            [self.dataSource removeAllObjects];
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
//        for (NSDictionary *dict in dic[@"subjects"]) {
//            CYMovie *movie = [[CYMovie alloc] initWithDic:dict];
//            
//        }
        
        //JsonModel
        for (NSDictionary *dict in dic[@"subjects"]) {
            CYJSONMovieModel *model = [[CYJSONMovieModel alloc] initWithDictionary:dict error:nil];
            [self.dataSource addObject:model];
            
            [[CYDataBase sharedDataBase] insertDataWithModel:model];
        }
        
        //数据加载完成之后  刷新UI
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    
    //检测网络
    //开始检测网络
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable)
        {
            if(self.dataSource.count == 0)
            {
                self.dataSource = [[CYDataBase sharedDataBase] getAllMovies];
                [self.tableView reloadData];
            }
        }
        else if(status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN)
        {
            if(self.dataSource.count == 0)
            {
                //请求数据
                [self startRequestData];
            }
        }
    }];
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
