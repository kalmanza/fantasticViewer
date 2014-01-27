//
//  HomeViewController.m
//  FanstasticViewer
//
//  Created by Kevin Almanza on 1/2/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import "HomeViewController.h"
#import "DataManager.h"
#import "LetterGroupViewController.h"
#import "HeroSubcatViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    
}
@property(nonatomic, strong)NSArray *dataSourceLetters;
@property(nonatomic, strong)NSArray *dataSource;
@property(nonatomic, strong)IBOutlet UITableView *tvCharacters;
@property(weak, nonatomic)IBOutlet UISearchBar *searchBar;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = self.dataSourceLetters;
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
        [self setTitle:@"MARVEL DATABASE"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self searchBar:_searchBar textDidChange:[_searchBar text]];
}

- (NSArray *)dataSourceLetters
{
    if (!_dataSourceLetters) {
        NSMutableArray *mutableLetters = [[NSMutableArray alloc] init];
        for (char i = 'A'; i <= 'Z'; i++) {
            [mutableLetters addObject:[NSString stringWithFormat:@"%c",i]];
        }
        _dataSourceLetters = mutableLetters;
    }
    return _dataSourceLetters;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell.textLabel setText:_dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![_dataSource isEqualToArray:self.dataSourceLetters]) {
        HeroSubcatViewController *hsc = [[HeroSubcatViewController alloc] init];
        NSString *heroName = cell.textLabel.text;
        [hsc setDataSource:[[DataManager sharedManager] universesForHeroName:heroName]];
        [hsc setTitle:heroName];
        
        [self.navigationController pushViewController:hsc animated:YES];
        
    } else {
        LetterGroupViewController *lgvc = [[LetterGroupViewController alloc] init];
        DataManager *manager = [DataManager sharedManager];
        NSArray *heroKeys = [manager heroNamesWithPrefix:cell.textLabel.text];
        [lgvc setDataSource:heroKeys];
        [lgvc setTitle:cell.textLabel.text];
        
        [self.navigationController pushViewController:lgvc animated:YES];
    }
}

#pragma mark SearchBar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self searchBar:searchBar textDidChange:searchBar.text];
    [_tvCharacters setContentOffset:CGPointMake(0, 0)];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (![[searchBar text] length]) {
        _dataSource = self.dataSourceLetters;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length]) {
        _dataSource = [[DataManager sharedManager] heroNamesWithPrefix:searchText];
    } else {
        _dataSource = self.dataSourceLetters;
    }
    [_tvCharacters reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar setText:@""];
    [self.view endEditing:YES];
    _dataSource = self.dataSourceLetters;
    [_tvCharacters reloadData];
}

- (void)keyboardShown:(NSNotification *)note
{
    NSDictionary *userInfo = [note valueForKey:@"userInfo"];
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect frame = value.CGRectValue;
    frame = [[[UIApplication sharedApplication] keyWindow] convertRect:frame toView:self.view];
    [_tvCharacters setFrame:CGRectMake(0, _tvCharacters.frame.origin.y, self.view.bounds.size.width, frame.origin.y -self.searchBar.frame.size.height)];
    [_tvCharacters reloadData];
}

- (void)keyboardHidden:(NSNotification *)note
{
    [_tvCharacters setFrame:CGRectMake(0, _tvCharacters.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - _searchBar.frame.size.height)];
}

@end
