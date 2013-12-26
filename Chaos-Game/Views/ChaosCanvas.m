//
//  ChaosCanvas.m
//  Chaos-Game
//
//  Created by Chad Edrupt on 26/12/2013.
//  Copyright (c) 2013 Ultrasoft. All rights reserved.
//

#import "ChaosCanvas.h"

@interface ChaosCanvas()

@end

@implementation ChaosCanvas

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit
{
    
}

- (void) initGestureRecognizers
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    tapRecognizer.numberOfTouchesRequired = 3;
    
}

#pragma mark



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
