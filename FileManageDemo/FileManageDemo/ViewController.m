//
//  ViewController.m
//  FileManageDemo
//
//  Created by dengtao on 2017/7/11.
//  Copyright © 2017年 JingXian. All rights reserved.
//

#import "ViewController.h"
#import "FCFileManager.h"
#import "PunchScrollView.h"
#import "SlidingSegmentControl.h"
#import "FileManager.h"

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

#define kOriginY 64

@interface ViewController ()<SlidingSegmentControlDelegate,PunchScrollViewDelegate,PunchScrollViewDataSource,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) PunchScrollView           *scrollView;
@property(nonatomic, strong) SlidingSegmentControl   *slidingSegControl;

@property(nonatomic, assign) NSInteger                 currentPage;

@property(nonatomic, strong) UITableView               *tableView;
@property(nonatomic, strong) NSMutableArray            *dataScourceArray;

@property (nonatomic, strong) NSFileManager *fileManager;//创建文件管理器
@property (nonatomic, copy) NSString *documentsDirectory;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentPage = 0;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.slidingSegControl];
    [self.view addSubview:self.scrollView];
    
    [self writeFileInSanBox];
    
    NSString *myDirectory = [self.documentsDirectory stringByAppendingPathComponent:@"test"];
    NSArray *fileArray = [FCFileManager listFilesInDirectoryAtPath:self.documentsDirectory withSuffix:@".txt" deep:YES];
    
    NSArray *allFileArray  =[FCFileManager listFilesInDirectoryAtPath:self.documentsDirectory deep:YES];
    NSLog(@"沙盒文件:\n%@",fileArray);
    
}


//在 NSDocumentDirectory 下创建test 文件夹 创建test00.text 文件
- (void)writeFileInSanBox{

    NSLog(@"沙盒路径:\n%@",self.documentsDirectory);
    
    // 创建目录
    [self.fileManager createDirectoryAtPath:self.documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    NSString *testPath = [self.documentsDirectory stringByAppendingPathComponent:@"test00.txt"];
    NSString *testPath2 = [self.documentsDirectory stringByAppendingPathComponent:@"test22.txt"];
    NSString *testPath3 = [self.documentsDirectory stringByAppendingPathComponent:@"test33.txt"];
    
    
    NSString *string = @"写入内容，write String";
    [self.fileManager createFileAtPath:testPath contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    [self.fileManager createFileAtPath:testPath2 contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    [self.fileManager createFileAtPath:testPath3 contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
}

#pragma mark - Action
- (IBAction)loadPicture:(UIButton *)sender {

    NSLog(@"%@",sender.titleLabel.text);
}
- (IBAction)loadAudio:(UIButton *)sender {
    
    NSLog(@"%@",sender.titleLabel.text);
}


#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *idenfiter = @"FileManagerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfiter];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfiter];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = @"测试一下";
    return cell;
}

- (void)tableView:(UITableView *)tableView deselectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//PunchScrollView
- (NSInteger)punchscrollView:(PunchScrollView *)scrollView numberOfPagesInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)punchScrollView:(PunchScrollView *)scrollView viewForPageAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.page)
    {
        case 0:
        {
            self.tableView = [self getTableView];
            self.tableView.backgroundColor = [UIColor orangeColor];
            [self.tableView reloadData];
            return self.tableView;
        }
            break;
        case 1:
        {
            self.tableView = [self getTableView];
            self.tableView.backgroundColor = [UIColor purpleColor];
            [self.tableView reloadData];
            return self.tableView;
        }
           
            break;
        case 2:
        {
            self.tableView = [self getTableView];
            self.tableView.backgroundColor = [UIColor greenColor];
            [self.tableView reloadData];
            return self.tableView;
        }
            break;
        case 3:
        {
            self.tableView = [self getTableView];
            self.tableView.backgroundColor = [UIColor redColor];
            [self.tableView reloadData];
            return self.tableView;
        }
            break;
        case 4:
        {
            self.tableView = [self getTableView];
            self.tableView.backgroundColor = [UIColor grayColor];
            [self.tableView reloadData];
            return self.tableView;
        }
            break;
            
        default:
        {
            self.tableView = [self getTableView];
            [self.tableView reloadData];
            return self.tableView;
        }
            break;
    }
}

// GCSlidingSegmentedControl
- (void)slidingSegmentedControl:(SlidingSegmentControl *)control didSelectedItemAtIndex:(NSInteger)index
{
    if (index != self.scrollView.currentIndexPath.page)
    {
        _currentPage = index;
        [self.scrollView scrollToIndexPath:[NSIndexPath indexPathForPage:index inSection:0] animated:YES];
    }
}

//UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //根据当前的坐标与页宽计算当前页码
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (page != _currentPage && fabs(scrollView.contentOffset.x) >= fabs(scrollView.contentOffset.y)) {
        _currentPage = page;
        [self.slidingSegControl selectItemAtIndex:page scrollAnimated:YES];
    }
}


#pragma mark  - Setter/Getter
- (NSFileManager *)fileManager{

    if (_fileManager == nil) {
        
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (NSString *)documentsDirectory{

    if (_documentsDirectory == nil) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentsDirectory = [paths objectAtIndex:0];
    }
    return _documentsDirectory;
}

-(SlidingSegmentControl *)slidingSegControl{
    
    if (_slidingSegControl == nil) {
        
        NSMutableArray *items = [NSMutableArray new];
        NSArray *titlesArray = @[@"全部",@"文档",@"图片",@"视频",@"其他"];
        for (NSString *title in titlesArray) {
            
            SlidingSegmentControlItem *item = [[SlidingSegmentControlItem alloc] init];
            item.title = title;
            [items addObject:item];
        }
        
        _slidingSegControl = [SlidingSegmentControl slidingSegmentControlWithFrame:CGRectMake(0, kOriginY, kScreenWidth, 50)];
        _slidingSegControl.tintColor = [UIColor redColor];
        _slidingSegControl.backgroundColor = [UIColor whiteColor];
        _slidingSegControl.controlDelegate = self;
        _slidingSegControl.items = items;
        _slidingSegControl.itemNumberForOnePage = 5;
    }
    return _slidingSegControl;
}

- (PunchScrollView *)scrollView{
    
    if (_scrollView == nil) {
        
        _scrollView = [[PunchScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_slidingSegControl.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(_slidingSegControl.frame))];
        _scrollView.pagePadding = 10.0;
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.dataSource = self;
        //        _scrollView.infiniteScrolling = NO;
    }
    return _scrollView;
}

- (UITableView *)getTableView{
    
       UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), kScreenWidth,kScreenHeight -  CGRectGetMaxY(_slidingSegControl.frame)) style:UITableViewStylePlain];
       tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
       tableView.dataSource = self;
       tableView.delegate = self;
       tableView.rowHeight = 44;
    
    return tableView;
}

- (NSMutableArray *)dataScourceArray{

    if (_dataScourceArray == nil) {
        
        _dataScourceArray = [[NSMutableArray alloc] init];
    }
    return _dataScourceArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
