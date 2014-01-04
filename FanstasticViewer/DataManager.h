//
//  DataManager.h
//  FanstasticViewer
//
//  Created by Kevin Almanza on 1/3/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property(nonatomic, strong) NSMutableDictionary *marvelDict;

+ (DataManager *)sharedManager;
- (void)fetchDataFromWiki;

@end
