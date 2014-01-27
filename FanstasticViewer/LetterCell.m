//
//  LetterCell.m
//  FanstasticViewer
//
//  Created by Kevin Almanza on 1/26/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import "LetterCell.h"

@implementation LetterCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height)];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        [self setBackgroundColor:[UIColor grayColor]];
        [self addSubview:_textLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
