//
//  ViewController.m
//  UITableViewCustomCellSample
//
//  Created by yasuhisa.arakawa on 2014/04/12.
//  Copyright (c) 2014年 Yasuhisa Arakawa. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"
#import "TableViewConst.h"
#import "DetailViewController.h"

/**
 *  テーブルビューのセクション数が入ります。
 */
static NSInteger const ViewControllerTableSecsion   = 2;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

/**
 *  Storyboardに配置したテーブルが紐づいてます。
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  Storyboardに配置したサーチバーが紐づいてます。
 */
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

/**
 *  テーブルに表示する情報が入ります。
 */
@property (nonatomic, strong) NSArray *dataSourceiPhone;
@property (nonatomic, strong) NSArray *dataSourceAndroid;

/**
 *  テーブルに表示する検索結果が入ります。
 */
@property (nonatomic, strong) NSArray *dataSourceSearchResultsiPhone;
@property (nonatomic, strong) NSArray *dataSourceSearchResultsAndroid;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation ViewController

#pragma mark - Lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // デリゲートメソッドをこのクラスで実装する
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchDisplayController.delegate = self;
    
    // テーブルに表示したいデータソースをセット
    self.dataSourceiPhone = @[@"iPhone 4", @"iPhone 4S", @"iPhone 5", @"iPhone 5c", @"iPhone 5s"];
    self.dataSourceAndroid = @[@"Nexus", @"Galaxy", @"Xperia"];
    
    // カスタマイズしたセルをテーブルビューにセット
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:TableViewCustomCellIdentifier bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:_selectedIndexPath animated:YES];
    }
    
    if (self.searchDisplayController.isActive) {
        [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:_selectedIndexPath animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource delegate methods

/**
 *  テーブルに表示するデータ件数を返します。（実装必須）
 *
 *  @param tableView テーブルビュー
 *  @param section   対象セクション番号
 *
 *  @return データ件数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger dataCount;
    
    // ここのsearchDisplayControllerはStoryboardで紐付けされたsearchBarに自動で紐づけられています
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        switch (section) {
            case 0:
                dataCount = self.dataSourceSearchResultsiPhone.count;
                break;
            case 1:
                dataCount = self.dataSourceSearchResultsAndroid.count;
                break;
            default:
                break;
        }
    } else {
        switch (section) {
            case 0:
                dataCount = self.dataSourceiPhone.count;
                break;
            case 1:
                dataCount = self.dataSourceAndroid.count;
                break;
            default:
                break;
        }
    }
    return dataCount;
}

/**
 *  テーブルに表示するセクション（区切り）の件数を返します。（任意実装）
 *
 *  @param  テーブルビュー
 *
 *  @return セクション件数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ViewControllerTableSecsion;
}

/**
 *  テーブルに表示するセルを返します。（実装必須）
 *
 *  @param tableView テーブルビュー
 *  @param indexPath セクション番号・行番号の組み合わせ
 *
 *  @return セル
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // ここのsearchDisplayControllerはStoryboardで紐付けされたsearchBarに自動で紐づけられています
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        // 検索中の暗転された状態のテーブルビューはこちらで処理
        switch (indexPath.section) {
            case 0: // iOSの検索結果を表示する
                cell.imageThumb.image = [UIImage imageNamed:@"ios1-100x100"];
                cell.labelDeviceName.text = self.dataSourceSearchResultsiPhone[indexPath.row];
                break;
            case 1: // Androidの検索結果を表示する
                cell.imageThumb.image = [UIImage imageNamed:@"android-200x200"];
                cell.labelDeviceName.text = self.dataSourceSearchResultsAndroid[indexPath.row];
                break;
            default:
                break;
        }
    } else {
        // 通常時のテーブルビューはこちらで処理
        switch (indexPath.section) {
            case 0: // iOS
                cell.imageThumb.image = [UIImage imageNamed:@"ios1-100x100"];
                cell.labelDeviceName.text = self.dataSourceiPhone[indexPath.row];
                break;
            case 1: // Android
                cell.imageThumb.image = [UIImage imageNamed:@"android-200x200"];
                cell.labelDeviceName.text = self.dataSourceAndroid[indexPath.row];
                break;
            default:
                break;
        }
    }
    
    cell.labelCellNumber.text = [NSString stringWithFormat:@"セル番号：%ld", (long)indexPath.row + 1];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

/**
 *  テーブルのセルがタップされた時に呼ばれます。
 *
 *  @param tableView テーブルビュー
 *  @param indexPath セクション番号・行番号の組み合わせ
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    // セグエを呼び出して画面遷移します。
    [self performSegueWithIdentifier:@"pushDetailView" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CustomTableViewCell rowHeight];
}

#pragma mark - Segue method

/**
 *  セグエでの画面遷移前に呼び出されます。
 *
 *  @param segue  セグエ（pushを選択したやつ）
 *  @param sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 遷移先を取得します
    DetailViewController *detailViewController = segue.destinationViewController;
    
    // 詳細画面に画像名をセット
    detailViewController.imageName = (_selectedIndexPath.section == 0) ? @"ios1-100x100" : @"android-200x200";
    
    if (self.searchDisplayController.isActive) {
        // 詳細画面に検索したデータソースからデバイス名をセット
        switch (_selectedIndexPath.section) {
            case 0: // iOS
                detailViewController.labelDeviceName = _dataSourceSearchResultsiPhone[_selectedIndexPath.row];
                break;
            case 1: // Android
                detailViewController.labelDeviceName = _dataSourceSearchResultsAndroid[_selectedIndexPath.row];
                break;
            default:
                break;
        }
    } else {
        // 詳細画面にデータソースからデバイス名をセット
        switch (_selectedIndexPath.section) {
            case 0: // iOS
                detailViewController.labelDeviceName = _dataSourceiPhone[_selectedIndexPath.row];
                break;
            case 1: // Android
                detailViewController.labelDeviceName = _dataSourceAndroid[_selectedIndexPath.row];
                break;
            default:
                break;
        }
    }
}

#pragma mark - UISearchDisplayDelegate method

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // 検索バーに入力された文字列を引数に、絞り込みをかけます
    [self filterContainsWithSearchText:searchString];
    
    // YESを返すとテーブルビューがリロードされます。
    // リロードすることでdataSourceSearchResultsiPhoneとdataSourceSearchResultsAndroidからテーブルビューを表示します
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 検索開始時に、ナビゲーションバーを隠します。
    self.searchDisplayController.searchContentsController.navigationController.navigationBarHidden = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 検索終了時にナビゲーションバーを表示します。
    self.searchDisplayController.searchContentsController.navigationController.navigationBarHidden = NO;
}

#pragma mark - Private method

- (void)filterContainsWithSearchText:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    
    self.dataSourceSearchResultsiPhone = [self.dataSourceiPhone filteredArrayUsingPredicate:predicate];
    self.dataSourceSearchResultsAndroid = [self.dataSourceAndroid filteredArrayUsingPredicate:predicate];
}

@end
