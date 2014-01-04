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

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)IBOutlet UITableView *tvCharacters;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tvCharacters setDataSource:self];
    [self.tvCharacters setDelegate:self];
    [[DataManager sharedManager] fetchDataFromWiki];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        for (char i = 'A'; i <= 'Z'; i++) {
            [_dataSource addObject:[NSString stringWithFormat:@"%c",i]];
        }
    }
    return _dataSource;
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
    LetterGroupViewController *lgvc = [[LetterGroupViewController alloc] init];
    DataManager *manger = [DataManager sharedManager];
    NSMutableDictionary *marvelDict = manger.marvelDict;
    char selectedChar = 'A' + indexPath.row;
    NSString *selectedCharString = [NSString stringWithFormat:@"%c",selectedChar];
    NSMutableDictionary *letter_hero = [marvelDict objectForKey:selectedCharString];
    NSMutableArray *heroKeys = letter_hero.allKeys.mutableCopy;
    [heroKeys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    [lgvc setDataSource:heroKeys];
    [self.navigationController pushViewController:lgvc animated:YES];
}

@end
