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

typedef NS_ENUM(NSInteger, FVSelectionState) {
    FVSelectionStateLetters,
    FVSelectionStateCharacters,
    FVSelectionStateUniverses
};

@interface LetterCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSArray *_mainDataSource;
    BOOL _inTransition;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *herosLayout;
@property (nonatomic, strong) UICollectionViewFlowLayout *letterLayout;
@property (nonatomic, strong) NSArray *dataSourceLetters;
@property (nonatomic) FVSelectionState state;

@end

@implementation LetterCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _mainDataSource = self.dataSourceLetters;
        _inTransition = NO;
        [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupHeroLayout];
    [self setupLetterLayout];
    [self setupCollectionView];
    [self setupNavBar];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"]) {
        [self updateForNewState];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)updateForNewState
{
    UIBarButtonItem *leftItem = [UIBarButtonItem alloc];
    switch (_state) {
        case FVSelectionStateLetters:
        {
            leftItem = [leftItem initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(backButtonPressed)];
            break;
        }
        case FVSelectionStateCharacters:
        {
            leftItem = [leftItem initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(backButtonPressed)];
            break;
        }
        case FVSelectionStateUniverses:
        {
            leftItem = [leftItem initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(backButtonPressed)];
            break;
        }
    }
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

- (void)backButtonPressed
{
    switch (_state) {
        case FVSelectionStateLetters:
        {
            break;
        }
        case FVSelectionStateCharacters:
        {
            @try {
                _mainDataSource = self.dataSourceLetters;
                _inTransition = YES;
                [_collectionView reloadData];
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                [_collectionView setCollectionViewLayout:_letterLayout animated:YES completion:^(BOOL finished) {
                    if (finished) {
                        [self setState:FVSelectionStateLetters];
                        _inTransition = NO;
                    }
                }];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.description);
            }
            @finally {
            }
            break;
        }
        case FVSelectionStateUniverses:
        {
            break;
        }
    }
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

- (void)setupNavBar
{
    [self setTitle:@"Browse"];
    self.state = FVSelectionStateLetters;
}

- (void)setupHeroLayout
{
    _herosLayout = [[UICollectionViewFlowLayout alloc] init];
    [_herosLayout setMinimumInteritemSpacing:0.0];
    [_herosLayout setMinimumLineSpacing:30.0];
    [_herosLayout setItemSize:CGSizeMake(240, 100)];
}

- (void)setupLetterLayout
{
    _letterLayout = [[UICollectionViewFlowLayout alloc] init];
    [_letterLayout setMinimumInteritemSpacing:10.0];
    [_letterLayout setMinimumLineSpacing:30.0];
    [_letterLayout setItemSize:CGSizeMake(100, 100)];
}

- (void)setupCollectionView
{
    [_collectionView registerClass:[LetterCell class] forCellWithReuseIdentifier:@"reuse"];
    [_collectionView setCollectionViewLayout:_letterLayout];
    [_collectionView setBackgroundColor:[UIColor darkGrayColor]];
    [_collectionView setContentInset:UIEdgeInsetsMake(20, 40, 20, 40)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_mainDataSource count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LetterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    [cell.textLabel setText:_mainDataSource[indexPath.row]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:22]];
    if (_inTransition) {
        [cell.textLabel setAlpha:0.0];
        [UIView animateWithDuration:.8 animations:^{
            cell.textLabel.alpha = 1;
        }];
    }
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LetterCell *cell = (LetterCell *)[collectionView cellForItemAtIndexPath:indexPath];
    switch (_state) {
        case FVSelectionStateLetters:
        {
            NSArray *heroNames = [[DataManager sharedManager] heroNamesWithPrefix:cell.textLabel.text];
            _mainDataSource = heroNames;
            _inTransition = YES;
            [_collectionView reloadData];
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            [_collectionView setCollectionViewLayout:_herosLayout animated:YES completion:^(BOOL finished) {
                if (finished) {
                    self.state = FVSelectionStateCharacters;
                    _inTransition = NO;
                }
            }];
            break;
        }
        case FVSelectionStateCharacters:
        {
            break;
        }
        case FVSelectionStateUniverses:
        {
            break;
        }
    }
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

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"state"];
}

@end
