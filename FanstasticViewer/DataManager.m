//
//  DataManager.m
//  FanstasticViewer
//
//  Created by Kevin Almanza on 1/3/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import "DataManager.h"

NSString *const marvelURL = @"http://marvel.wikia.com";

@interface DataManager ()
{
    NSMutableDictionary *_marvelDict;
}

@end

@implementation DataManager

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (DataManager *)sharedManager
{
    static DataManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[DataManager alloc] init];
        }
    });
    return sharedManager;
}

- (NSDictionary *)marvelDict
{
        return _marvelDict;
}

- (void)load
{
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    if (!urls) {
        NSLog(@"no url directory on load");
    }
    NSURL *docsDirectory = [urls lastObject];
    NSURL *marvelDictURL = [docsDirectory URLByAppendingPathComponent:@"marvelDict.archive"];
    if (!_marvelDict) {
        _marvelDict = [NSKeyedUnarchiver unarchiveObjectWithFile:marvelDictURL.path];
        if (!_marvelDict) {
            _marvelDict = [[NSMutableDictionary alloc] init];
            [self fetchDataFromWiki];
        }
    }
}

- (void)fetchDataFromWiki
{
    static NSString *offset = @"0";
    static BOOL finishedDownload = NO;
    finishedDownload = NO;
    NSString *apiurl = [NSString stringWithFormat:@"http://marvel.wikia.com/api/v1/Articles/List?expand=1&category=characters&limit=5000&offset=%@",offset];
    apiurl = [apiurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *ephemeralConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *emphemeralSession = [NSURLSession sessionWithConfiguration:ephemeralConfig];
    [[emphemeralSession dataTaskWithURL:[NSURL URLWithString:apiurl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"got response:\n\t%@\n", response);
        if (!response) {
            [self saveData];
            return;
        }
        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if ([responseDict objectForKey:@"exception"]) {
            return;
        }
        NSMutableDictionary *tokens = [[NSMutableDictionary alloc] init];
        for (NSDictionary *entry in [responseDict objectForKey:@"items"]) {
            tokens = [self parseEntry:entry];
            [self addEntryToMarvelDict:tokens];
        }
        NSString *newOffset = [responseDict objectForKey:@"offset"];
        offset = newOffset;
        NSLog(@"New Offset:%@",newOffset);
        if (offset == nil) {
            [self saveData];
            finishedDownload = YES;
            return;
        }
        [self fetchDataFromWiki];
        
    }] resume];
}

- (NSMutableDictionary *)parseEntry:(NSDictionary*)entry
{
    NSString *title = [entry objectForKey:@"title"];
    NSRange range;
    NSString *heroName = @"";
    NSString *heroDetails = @"";
    NSString *stringURL = @"none";
    
    range = [title rangeOfString:@"("];
    if (range.length) {
        heroName = [title substringToIndex:range.location -1];
        heroDetails = [title substringFromIndex:range.location];
        stringURL = [entry objectForKey:@"url"];
    } else {
        heroName = title;
    }
    
    NSMutableDictionary *tokens = @{@"name": heroName, @"details": heroDetails, @"url": stringURL}.mutableCopy;
    
    return tokens;
}

- (void)addEntryToMarvelDict:(NSMutableDictionary *)tokens
{
    NSString *heroName = tokens[@"name"];
    NSString *heroDetails = tokens[@"details"];
    NSString *heroURL = tokens[@"url"];
    NSDictionary *details_url = @{heroDetails:heroURL};
    NSMutableArray *heroNameArray;
    NSMutableDictionary *letterValue = [_marvelDict objectForKey:[NSString stringWithFormat:@"%c",[heroName characterAtIndex:0]]];
    if (!letterValue) {
        [_marvelDict setObject:[[NSMutableDictionary alloc] init] forKey:[NSString stringWithFormat:@"%c",[heroName characterAtIndex:0]]];
        letterValue = [_marvelDict objectForKey:[NSString stringWithFormat:@"%c",[heroName characterAtIndex:0]]];
        heroNameArray = [letterValue objectForKey:heroName];
        if (!heroNameArray) {
            [letterValue setObject:[[NSMutableArray alloc]init] forKey:heroName];
            heroNameArray = [letterValue objectForKey:heroName];
            [heroNameArray addObject:details_url];
        }

    } else {
        heroNameArray = [letterValue objectForKey:heroName];
        if (!heroNameArray) {
            [letterValue setObject:[[NSMutableArray alloc]init] forKey:heroName];
            heroNameArray = [letterValue objectForKey:heroName];
            [heroNameArray addObject:details_url];
        } else {
            [heroNameArray addObject:details_url];
        }

    }
    
}

- (void)saveData
{
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    if (!urls) {
        NSLog(@"no url directory on save");
    }
    NSURL *docsDirectory = [urls lastObject];
    NSURL *marvelDictURL = [docsDirectory URLByAppendingPathComponent:@"marvelDict.archive"];
    [NSKeyedArchiver archiveRootObject:_marvelDict toFile:marvelDictURL.path];
    
}

@end
