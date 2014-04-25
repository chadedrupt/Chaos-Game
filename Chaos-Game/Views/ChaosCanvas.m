//
//  ChaosCanvas.m
//  Chaos-Game
//
//  Created by Chad Edrupt on 26/12/2013.
//  Copyright (c) 2013 Ultrasoft. All rights reserved.
//

#import "ChaosCanvas.h"

@interface ChaosCanvas()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) CGPoint currentPoint;
@property (nonatomic, strong) NSArray *cornerLocations;
@property (nonatomic) CGLayerRef drawingLayer;

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
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    self.currentPoint = [self randomCorner];
}

- (void) resetCanvas {
    self.cornerLocations = nil;
    self.drawingLayer = nil;
    self.currentPoint = [self randomCorner];
}

#pragma mark Getters and Setters

- (NSArray*) cornerLocations {
    if (_cornerLocations) {
        return _cornerLocations;
    }
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat smallSpan = fmin(width, height);
    CGFloat largeSpan = sqrt(pow(smallSpan, 2) - pow(smallSpan / 2, 2)); //pythagoras theorem
    
    CGFloat xPadding = width < height ? width - smallSpan : width - largeSpan;
    CGFloat yPadding = width < height ? height - largeSpan : height - smallSpan;
    
    CGRect triangleRect = CGRectIntegral(CGRectInset(self.bounds, xPadding / 2.0, yPadding / 2.0));
    
    _cornerLocations = @[
                            [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(triangleRect), CGRectGetMinY(triangleRect))],
                            [NSValue valueWithCGPoint:CGPointMake(CGRectGetMinX(triangleRect), CGRectGetMaxY(triangleRect))],
                            [NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(triangleRect), CGRectGetMaxY(triangleRect))]
                         ];
    return _cornerLocations;
}

- (CGLayerRef) drawingLayer {
    if (_drawingLayer) {
        return _drawingLayer;
    }
    
    _drawingLayer = CGLayerCreateWithContext(UIGraphicsGetCurrentContext(), self.bounds.size, NULL);
    return _drawingLayer;
}

#pragma mark Maths

- (CGPoint) randomCorner {
    NSValue *corner = self.cornerLocations[arc4random_uniform((uint32_t)self.cornerLocations.count)];
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
    [self algorithm];
    
    [self setNeedsDisplay];
}

- (void)drawPoint:(CGPoint)point withSize:(CGFloat)diameter inContext:(CGContextRef)context
{
    if (diameter <= 1) {
        CGContextMoveToPoint(context, round(point.x * 2.0) / 2.0, round(point.y * 2.0) / 2.0);
        CGContextAddLineToPoint(context, round(point.x * 2.0) / 2.0 + 0.5, round(point.y * 2.0) / 2.0 + 0.5);
        CGContextStrokePath(context);
    } else {
        CGContextFillEllipseInRect(context, CGRectMake(point.x - (diameter / 2),
                                                       point.y - (diameter / 2),
                                                       diameter, diameter));
    }
}

- (void)drawRect:(CGRect)rect
{
    // First draw our next point to our layer
    CGContextRef layerContext = CGLayerGetContext(self.drawingLayer);
    [self drawPoint:self.currentPoint withSize:1.0 inContext:layerContext];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // draw our layer onto the screen
    CGContextDrawLayerAtPoint(context, CGPointZero, self.drawingLayer);
    // draw our temporary current position in to the screen
    [self drawPoint:self.currentPoint withSize:16.0 inContext:context];
}


@end
