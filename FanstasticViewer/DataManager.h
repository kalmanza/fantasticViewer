//
//  DataManager.h
//  FanstasticViewer
//
//  Created by Kevin Almanza on 1/3/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DataManager : NSObject

extern NSString *const marvelURL;

//access shared instance
+ (DataManager *)sharedManager;


//access the entire marvel dictionary
- (NSDictionary *)marvelDict;


//call to populate marvel dictionary with data
- (void)load;

@end
