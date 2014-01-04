//
//  DataManager.m
//  FanstasticViewer
//
//  Created by Kevin Almanza on 1/3/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import "DataManager.h"

@interface DataManager ()

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

- (NSMutableDictionary *)marvelDict
{
    if (!_marvelDict) {
        _marvelDict = [[NSMutableDictionary alloc] init];
    }
    return _marvelDict;
}

- (void)fetchDataFromWiki
{
   // [self parseEntry:@{@"title":@"toast (something else here) (earth-616)"}];
    static NSString *offset = @"0";
    NSString *apiurl = [NSString stringWithFormat:@"http://marvel.wikia.com/api/v1/Articles/List?expand=1&category=characters&limit=10000&offset=%@",offset];
    apiurl = [apiurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *ephemeralConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *emphemeralSession = [NSURLSession sessionWithConfiguration:ephemeralConfig];
    [[emphemeralSession dataTaskWithURL:[NSURL URLWithString:apiurl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"got response:\n\t%@\n", response);
        if (!response) {
            return;
        }
        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    //    NSLog(@"%@", responseDict);
        if ([responseDict objectForKey:@"exception"]) {
            return;
        }
        NSMutableDictionary *tokens = [[NSMutableDictionary alloc] init];
        for (NSDictionary *entry in [responseDict objectForKey:@"items"]) {
            tokens = [self parseEntry:entry];
            NSString *heroName = tokens[@"name"];
            if ([self.marvelDict objectForKey:[NSString stringWithFormat:@"%c",[heroName characterAtIndex:0]]])
            {
                NSMutableArray *letterArray = [self.marvelDict objectForKey:[NSString stringWithFormat:@"%c",[heroName characterAtIndex:0]]];
                [letterArray addObject:tokens];
            } else {
                NSMutableArray *letterArry = [[NSMutableArray alloc] init];
                [letterArry addObject:tokens];
                [self.marvelDict setObject:letterArry forKey:[NSString stringWithFormat:@"%c",[heroName characterAtIndex:0]]];
            }
        }
      //  [self.dataSource addObjectsFromArray:[responseDict objectForKey:@"items"]];
        NSString *newOffset = [responseDict objectForKey:@"offset"];
        offset = newOffset;
        NSLog(@"%@",newOffset);
        [self fetchDataFromWiki];
        
    }] resume];
}

- (NSMutableDictionary *)parseEntry:(NSDictionary*)entry
{
    NSString *title = [entry objectForKey:@"title"];
    NSRange range;
    NSString *heroName = @" ";
    NSString *heroDetails = @" ";
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

@end
