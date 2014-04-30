//
//  ChaosViewController.m
//  Chaos-Game
//
//  Created by Chad Edrupt on 23/04/2014.
//  Copyright (c) 2014 Edrupt & Co. All rights reserved.
//

#import "ChaosViewController.h"
#import "ChaosCanvas.h"

@interface ChaosViewController ()

@property (strong, nonatomic) IBOutlet ChaosCanvas *canvas;

@end

@implementation ChaosViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.canvas resetCanvas];
    [self.canvas startDrawing];
}

- (BOOL)shouldAutorotate
{
    return NO;
}


- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        [self.canvas resetCanvas];
    }
}
@end
