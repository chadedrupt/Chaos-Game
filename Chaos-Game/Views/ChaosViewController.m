//
//  ChaosViewController.m
//  Chaos-Game
//
//  Created by Chad Edrupt on 23/04/2014.
//  Copyright (c) 2014 Ultrasoft. All rights reserved.
//

#import "ChaosViewController.h"
#import "ChaosCanvas.h"

@interface ChaosViewController ()

@property (strong, nonatomic) IBOutlet ChaosCanvas *canvas;

@end

@implementation ChaosViewController

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.canvas performSelector:@selector(resetCanvas)
                      withObject:nil
                      afterDelay:duration];
}

@end
