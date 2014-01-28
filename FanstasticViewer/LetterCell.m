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
        [self.layer setShadowOffset:CGSizeMake(0, 2)];
        [self.layer setShadowOpacity:1.0];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowRadius:0.5];
    }
    return self;
}

- (void)layoutSubviews
{
    [_textLabel setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [_textLabel setNumberOfLines:2];
    [_textLabel setLineBreakMode:NSLineBreakByWordWrapping];
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
