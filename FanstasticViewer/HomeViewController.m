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

@property(nonatomic, strong)NSMutableArray *dataSourceLetters;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)IBOutlet UITableView *tvCharacters;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

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
        [self setTitle:@"MARVEL DICTIONARY"];
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
    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
}

- (NSMutableArray *)dataSourceLetters
{
    if (!_dataSourceLetters) {
        _dataSourceLetters = [[NSMutableArray alloc] init];
        for (char i = 'A'; i <= 'Z'; i++) {
            [_dataSourceLetters addObject:[NSString stringWithFormat:@"%c",i]];
        }
    }
    return _dataSourceLetters;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell.textLabel setText:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.textLabel.text.length == 1) {
        LetterGroupViewController *lgvc = [[LetterGroupViewController alloc] init];
        DataManager *manger = [DataManager sharedManager];
        NSMutableDictionary *marvelDict = manger.marvelDict;
        char selectedChar = 'A' + indexPath.row;
        NSString *selectedCharString = [NSString stringWithFormat:@"%c",selectedChar];
        NSMutableDictionary *letter_hero = [marvelDict objectForKey:selectedCharString];
        NSMutableArray *heroKeys = letter_hero.allKeys.mutableCopy;
        [heroKeys sortUsingSelector:@selector(compare:)];
        [lgvc setDataSource:heroKeys];
        [lgvc setTitle:selectedCharString];
        [self.navigationController pushViewController:lgvc animated:YES];
        
    } else if(cell.textLabel.text.length > 1) {
        HeroSubcatViewController *hsc = [[HeroSubcatViewController alloc] init];
        char firstChar = [cell.textLabel.text characterAtIndex:0];
        NSString *selectedCharString = [NSString stringWithFormat:@"%c", firstChar];
        DataManager *manager = [DataManager sharedManager];
        NSMutableDictionary *letter_hero = [manager.marvelDict objectForKey:selectedCharString.uppercaseString];
        NSString *name = cell.textLabel.text;
        NSMutableArray *universes = letter_hero[name];
        [hsc setDataSource:universes];
        [hsc setTitle:name];
        [self.navigationController pushViewController:hsc animated:YES];
    }
    
}

#pragma mark SearchBar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self searchBar:searchBar textDidChange:searchBar.text];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if ([searchBar.text length]) {
        
    } else {
        self.dataSource = self.dataSourceLetters;
        [self.tvCharacters reloadData];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length]) {
        char firstChar = [searchText characterAtIndex:0];
        NSString *selectedCharString = [NSString stringWithFormat:@"%c", firstChar];
        DataManager *manager = [DataManager sharedManager];
        NSMutableDictionary *letter_hero = [manager.marvelDict objectForKey:selectedCharString.uppercaseString];
        NSMutableArray *heroKeys = letter_hero.allKeys.mutableCopy;
        NSMutableArray *sorted = [heroKeys filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF like[c] %@",[searchText stringByAppendingString:@"*"]]].mutableCopy;
        [sorted sortUsingSelector:@selector(compare:)];
        self.dataSource = sorted;
    } else {
        self.dataSource = self.dataSourceLetters;
    }
    [self.tvCharacters reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.view endEditing:YES];
    self.dataSource = self.dataSourceLetters;
    [self.tvCharacters reloadData];
}

- (void)keyboardShown:(NSNotification *)note
{
    NSDictionary *userInfo = [note valueForKey:@"userInfo"];
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect frame = value.CGRectValue;
    frame = [[[UIApplication sharedApplication] keyWindow] convertRect:frame toView:self.view];
    [self.tvCharacters setFrame:CGRectMake(0, self.tvCharacters.frame.origin.y, self.view.bounds.size.width, frame.origin.y -self.searchBar.frame.size.height)];
    [self.tvCharacters reloadData];
}

- (void)keyboardHidden:(NSNotification *)note
{
    [self.tvCharacters setFrame:CGRectMake(0, self.tvCharacters.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - self.searchBar.frame.size.height)];
}

@end
