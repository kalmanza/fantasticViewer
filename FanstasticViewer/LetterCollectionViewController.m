//
//  LetterCollectionViewController.m
//  FanstasticViewer
//
//  Created by Kevin Almanza on 1/26/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import "LetterCollectionViewController.h"
#import "LetterCell.h"
#import "LetterGroupViewController.h"
#import "DataManager.h"

@interface LetterCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSArray *_dataSource;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *herosLayout;
@property (nonatomic, strong) NSArray *dataSourceLetters;

@end

@implementation LetterCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = self.dataSourceLetters;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupHeroLayout];
    [_collectionView registerClass:[LetterCell class] forCellWithReuseIdentifier:@"reuse"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:10.0];
    [flowLayout setMinimumLineSpacing:30.0];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [_collectionView setCollectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor darkGrayColor]];
    [_collectionView setContentInset:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self setTitle:@"Browse"];
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


- (void)setupHeroLayout
{
    _herosLayout = [[UICollectionViewFlowLayout alloc] init];
    [_herosLayout setMinimumInteritemSpacing:0];
    [_herosLayout setMinimumLineSpacing:30.0];
    [_herosLayout setItemSize:CGSizeMake(240, 100)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataSource count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LetterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    [cell.textLabel setText:_dataSource[indexPath.row]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:22]];
    [cell.layer setCornerRadius:5.0];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LetterCell *cell = (LetterCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSArray *heroNames = [[DataManager sharedManager] heroNamesWithPrefix:cell.textLabel.text];
    _dataSource = heroNames;
    [_collectionView setCollectionViewLayout:_herosLayout animated:YES completion:^(BOOL finished) {
        if (finished) {
            [_collectionView reloadData];
        }
    }];
    /*
    CharacterCollectionViewController *ccvc = [[CharacterCollectionViewController alloc] init];
    [ccvc setDataSource:heroNames];
    [ccvc setTitle:cell.textLabel.text];
    [self.navigationController pushViewController:ccvc animated:YES];
     */
}
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
}
 
 */

@end
