//
//  ChaosCanvas.m
//  Chaos-Game
//
//  Created by Chad Edrupt on 26/12/2013.
//  Copyright (c) 2013 Edrupt & Co. All rights reserved.
//

#import "ChaosCanvas.h"

@interface ChaosCanvas()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) CGPoint currentPoint;
@property (nonatomic) CGLayerRef drawingLayer;
@property NSMutableDictionary *touchLocations;

@end

@implementation ChaosCanvas

#pragma mark - Init

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
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshDisplay:)];
    self.displayLink.frameInterval = 1;
    self.displayLink.paused = YES;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    self.touchLocations = [[NSMutableDictionary alloc] init];
    
    self.currentPoint = [self randomCorner];
}

- (void) resetCanvas {
    self.drawingLayer = nil;
    self.currentPoint = [self randomCorner];
}

- (void) pauseDrawing {
    [self.displayLink setPaused:YES];
}
- (void) startDrawing {
    [self.displayLink setPaused:NO];
}

#pragma mark Getters and Setters

- (CGLayerRef) drawingLayer {
    if (_drawingLayer) {
        return _drawingLayer;
    }
    
    _drawingLayer = CGLayerCreateWithContext(UIGraphicsGetCurrentContext(), self.bounds.size, NULL);
    return _drawingLayer;
}

#pragma mark - UIView touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithPointer:(__bridge const void *)(touch)];
        NSValue *corner = [NSValue valueWithCGPoint:[touch locationInView:self]];
        
        if (!self.touchLocations[key]) {
            [self.touchLocations setObject:corner forKey:key];
        } else {
            self.touchLocations[key] = corner;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithPointer:(__bridge const void *)(touch)];
        NSValue *corner = [NSValue valueWithCGPoint:[touch locationInView:self]];
        
        if (!self.touchLocations[key]) {
            [self.touchLocations setObject:corner forKey:key];
        } else {
            self.touchLocations[key] = corner;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithPointer:(__bridge const void *)(touch)];
        
        if (!!self.touchLocations[key]) {
            [self.touchLocations removeObjectForKey:key];
        }
    }
}

#pragma mark Maths

- (CGPoint) randomCorner {
    NSArray *touches = [self.touchLocations allValues];
    
    if (touches.count < 1) {
        return CGPointZero;
    }
    
    NSValue *corner = touches[arc4random_uniform((uint32_t)touches.count)];
    
    return corner.CGPointValue;
}

- (CGPoint) midPointBetween:(CGPoint)a
                         and:(CGPoint)b {
    return CGPointMake((a.x + b.x) / 2.0,
                       (a.y + b.y) / 2.0);
}

#pragma mark The Algorithm

- (void) algorithm {
    // This is the algorithm, everything else is just here to visualize this one line.
    // This the only truely important thing.
    self.currentPoint = [self midPointBetween:self.currentPoint and:[self randomCorner]];
    //This seemingly chaotic algothim generates something far from chaotic.
}

#pragma mark Drawing

- (void) refreshDisplay:(CADisplayLink*)displayLink {
    [self setNeedsDisplay];
}

- (void)drawPoint:(CGPoint)point inContext:(CGContextRef)context
{
    CGContextMoveToPoint(context, floorf(point.x * 2.0) / 2.0, floorf(point.y * 2.0) / 2.0);
    CGContextAddLineToPoint(context, ceilf(point.x * 2.0) / 2.0, ceilf(point.y * 2.0) / 2.0);
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect
{
    // For each refresh draw 1000 points
    CGContextRef layerContext = CGLayerGetContext(self.drawingLayer);
    for (int i = 0; i < 1000; i++) {
        [self algorithm];
        [self drawPoint:self.currentPoint inContext:layerContext];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawLayerAtPoint(context, CGPointZero, self.drawingLayer);
}


@end
