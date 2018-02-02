//
//  ViewController.m
//  ZKSearchController
//
//  Created by Liuzikun on 2018/2/2.
//  Copyright © 2018年 Liuzikun. All rights reserved.
//

#import "ViewController.h"
//#import "JDYNativeSearchBar.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong)UITableView *tableview;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (nonatomic, strong)UISearchDisplayController *searchDisplayController;
#pragma clang diagnostic pop

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableview = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
    [self initSearchBar];
    self.view.backgroundColor = [UIColor cyanColor];
}

#pragma mark searchbar
-(void)initSearchBar
{
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 375, 44)];
//    searchBar.placeholder = @"搜索";
//
//    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    JDYNativeSearchBar *searchBar = [JDYNativeSearchBar alloc] initWithFrame:<#(CGRect)#>
//
//    self.tableview.tableHeaderView = searchBar;
    
//    JDYNativeSearchBar *searchBar = [[JDYNativeSearchBar alloc] initWithFrame:CGRectMake(0, 0, 375, 44)];
//
//    searchBar.placeholder = @"搜索";
//    searchBar.delegate = self;
//    [searchBar setViewBackgroundColor:[UIColor whiteColor]];
//    [searchBar setBarBackgroundColor:[UIColor colorWithRed:239.0/255 green:240.0/255 blue:244.0/255 alpha:1]];
//    [searchBar setBarCornerRadius:5];
//    [searchBar setPlaceholderAlignment:JDYNativeSearchBarPlaceholderAlignmentCenter];
//    [searchBar setSearchIcon:[UIImage imageNamed:@"icon_main_search"]];
//
//    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];

//    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
    
//    searchController.hidesNavigationBarDuringPresentation = NO;
//    searchController.dimsBackgroundDuringPresentation = YES;
//    self.searchDisplayController.delegate = self;
//    self.tableview.tableHeaderView = searchBar;
    
}



//- (void)setActive:(BOOL)visible animated:(BOOL)animated
//{
//    [super setActive: visible animated: animated];
//
//    [self.searchDisplayController.navigationController setNavigationBarHidden: NO animated: NO];
//}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.searchDisplayController.searchContentsController.navigationController.navigationBarHidden = NO;
//    [self commitControlClick:QNCtrlButtonSearch args:nil];
//    JDYOneSearchViewController *searchCenterVC = [[JDYOneSearchViewController alloc] initWithSearchType:JDYOneSearchBizTypeMessgeLocalContacts];
//    [searchCenterVC.contextDataSource loadUserContext:self.contextDataSource.loadedUserContext];
//    [self.navigationController pushViewController:searchCenterVC animated:YES];
    return YES;
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifer"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifer"];
        cell.textLabel.text = @"11";
    }
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
