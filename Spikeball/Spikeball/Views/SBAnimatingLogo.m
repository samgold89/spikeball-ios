//
//  SBAnimatingLogo.m
//  Spikeball
//
//  Created by Sam Goldstein on 11/25/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBAnimatingLogo.h"
#import "UIColor+SpikeballColors.h"

@interface SBAnimatingLogo ()

@property (nonatomic, assign) CGFloat lineSpacingValue;
@property (nonatomic, assign) CGFloat lineWidthValue;

@property (nonatomic, strong) UIImageView *sLogo;
@property (nonatomic, strong) CAShapeLayer *outerCircle;
@property (nonatomic, strong) CAShapeLayer *innerCircle;
@property (nonatomic, strong) CAShapeLayer *outerCircleFaded;
@property (nonatomic, strong) CAShapeLayer *innerCircleFaded;

@end

//        height 486   spacing 20    line 34     S-height 269
static CGFloat kHeightToSpacingMultiple = 0.04115226337;
static CGFloat kHeightToSHeightMultiple = 0.5534979424;
static CGFloat kHeightToLineWidthMultiple = 0.06995884774;

static CGFloat kFadedAlphaComponent = 0.3;

static NSString *kEraseYellowOuterKey = @"eraseYellowOuterKey";
static NSString *kDrawYellowOuterKey = @"drawYellowOuterKey";
static NSString *kEraseYellowInnerKey = @"eraseYellowInnerKey";
static NSString *kDrawYellowInnerKey = @"drawYellowInnerKey";

@implementation SBAnimatingLogo

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.lineSpacingValue = frame.size.height*kHeightToSpacingMultiple;
        self.lineWidthValue = frame.size.height*kHeightToLineWidthMultiple;
        
        self.sLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spikeball_yellow_logo_s"]];
        self.sLogo.frame = CGRectMake(0, 0, kHeightToSHeightMultiple*frame.size.width, kHeightToSHeightMultiple*frame.size.height);
        self.sLogo.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:self.sLogo];
        
        self.outerCircle = [[CAShapeLayer alloc] init];
        self.outerCircle.strokeColor = [UIColor spikeballYellow].CGColor;
        self.outerCircle.lineWidth = frame.size.height*kHeightToLineWidthMultiple;
        self.outerCircle.fillColor = nil;
        [self.layer addSublayer:self.outerCircle];
        
        self.innerCircle = [[CAShapeLayer alloc] init];
        self.innerCircle.strokeColor = [UIColor spikeballYellow].CGColor;
        self.innerCircle.lineWidth = frame.size.height*kHeightToLineWidthMultiple;
        self.innerCircle.fillColor = nil;
        [self.layer addSublayer:self.innerCircle];
        
        self.outerCircleFaded = [[CAShapeLayer alloc] init];
        self.outerCircleFaded.strokeColor = [[UIColor spikeballYellow] colorWithAlphaComponent:kFadedAlphaComponent].CGColor;
        self.outerCircleFaded.lineWidth = frame.size.height*kHeightToLineWidthMultiple;
        self.outerCircleFaded.fillColor = nil;
        [self.layer addSublayer:self.outerCircleFaded];
        
        self.innerCircleFaded = [[CAShapeLayer alloc] init];
        self.innerCircleFaded.strokeColor = [[UIColor spikeballYellow] colorWithAlphaComponent:kFadedAlphaComponent].CGColor;
        self.innerCircleFaded.lineWidth = frame.size.height*kHeightToLineWidthMultiple;
        self.innerCircleFaded.fillColor = nil;
        [self.layer addSublayer:self.innerCircleFaded];
        
        [self setCirclesFullPaths];
        
        [self startAllAnimations];
    }
    
    return self;
}

- (void)setCirclesFullPaths {
    UIBezierPath *outerFullPath = [[UIBezierPath alloc] init];
    [outerFullPath moveToPoint:CGPointMake(self.frame.size.width/2.0f, self.lineWidthValue/2)]; //start at top in center of where top line should be
    [outerFullPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2) radius:self.frame.size.height/2-self.lineWidthValue/2 startAngle:3*M_PI/2 endAngle:3*M_PI/2+2*M_PI clockwise:YES];
    
    UIBezierPath *innerFullPath = [[UIBezierPath alloc] init];
    [innerFullPath moveToPoint:CGPointMake(self.frame.size.width/2.0f, 1.5*self.lineWidthValue+self.lineSpacingValue)]; //starts after 1 line and 1 spacing, start in center, so 0.5*width
    [innerFullPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2) radius:self.frame.size.height/2-1.5*self.lineWidthValue-self.lineSpacingValue startAngle:3*M_PI/2 endAngle:3*M_PI/2+2*M_PI clockwise:YES];
    
    self.outerCircle.path = self.outerCircleFaded.path = outerFullPath.CGPath;
    self.innerCircle.path = self.innerCircleFaded.path = innerFullPath.CGPath;
    
    self.innerCircle.strokeStart = self.outerCircle.strokeStart = 0;
    self.innerCircle.strokeEnd = self.outerCircle.strokeEnd = 1;
}

- (void)startAllAnimations {
    [self stopAllAnimations];
    
    [self eraseYellowOuter];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self eraseYellowInner];
        [self startLogoAlphaPulse];
    });
}

- (void)stopAllAnimations {
    [self.innerCircle removeAllAnimations];
    [self.outerCircle removeAllAnimations];
    [self.sLogo.layer removeAllAnimations];
    [self setCirclesFullPaths];
}

- (void)startLogoAlphaPulse {
    CABasicAnimation *alphaPulse = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaPulse.duration = 1.1;
    alphaPulse.toValue = @0.82;
    alphaPulse.fromValue = @1;
    alphaPulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    alphaPulse.autoreverses = YES;
    alphaPulse.repeatCount = INFINITY;
    [self.sLogo.layer addAnimation:alphaPulse forKey:@"someKeyHere"];
}

- (void)startLogoSizePulse {
    CABasicAnimation *sizePulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    sizePulse.duration = 0.8;
    sizePulse.toValue = @1.05;
    sizePulse.autoreverses = YES;
    sizePulse.repeatCount = INFINITY;
    sizePulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.sLogo.layer addAnimation:sizePulse forKey:@"transformKey"];
}

- (void)eraseYellowOuter {
    self.outerCircle.strokeStart = 1;
    [self.outerCircle addAnimation:[self getAnimateEraseYellowAnimation] forKey:kEraseYellowOuterKey];
}

- (void)drawYellowOuter {
    [self.outerCircle addAnimation:[self getAnimateDrawYellowAnimation] forKey:kDrawYellowOuterKey];
    self.outerCircle.strokeEnd = 1;
    self.outerCircle.strokeStart = 0;
}

- (void)eraseYellowInner {
    self.innerCircle.strokeStart = 1;
    [self.innerCircle addAnimation:[self getAnimateEraseYellowAnimation] forKey:kEraseYellowInnerKey];
}

- (void)drawYellowInner {
    [self.innerCircle addAnimation:[self getAnimateDrawYellowAnimation] forKey:kDrawYellowInnerKey];
    self.innerCircle.strokeEnd = 1;
    self.innerCircle.strokeStart = 0;
}

- (CABasicAnimation*)getAnimateEraseYellowAnimation {
    CABasicAnimation *eraseYellowAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    eraseYellowAnimation.fromValue = @0;
    eraseYellowAnimation.toValue = @1;
    eraseYellowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    eraseYellowAnimation.duration = 2;
    eraseYellowAnimation.removedOnCompletion = NO;
    eraseYellowAnimation.delegate = self;
    
    return eraseYellowAnimation;
}

- (CABasicAnimation*)getAnimateDrawYellowAnimation {
    CABasicAnimation *drawYellowAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawYellowAnimation.fromValue = @-1;
    drawYellowAnimation.toValue = @1;
    drawYellowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    drawYellowAnimation.fillMode = kCAFillModeBackwards;
    drawYellowAnimation.duration = 2;
    drawYellowAnimation.removedOnCompletion = NO;
    drawYellowAnimation.delegate = self;
    
    return drawYellowAnimation;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([anim isEqual:[self.outerCircle animationForKey:kDrawYellowOuterKey]]) {
//        NSLog(@"outer DRAW yellow finished");
        [self.outerCircle removeAnimationForKey:kDrawYellowOuterKey];
        [self eraseYellowOuter];
    } else if ([anim isEqual:[self.outerCircle animationForKey:kEraseYellowOuterKey]]) {
//        NSLog(@"outer ERASE yellow finished");
        [self.outerCircle removeAnimationForKey:kEraseYellowOuterKey];
        [self drawYellowOuter];
    } else if ([anim isEqual:[self.innerCircle animationForKey:kDrawYellowInnerKey]]) {
//        NSLog(@"inner DRAW yellow finished");
        [self.innerCircle removeAnimationForKey:kDrawYellowInnerKey];
        [self eraseYellowInner];
    } else if ([anim isEqual:[self.innerCircle animationForKey:kEraseYellowInnerKey]]) {
//        NSLog(@"inner ERASE yellow finished");
        [self.innerCircle removeAnimationForKey:kEraseYellowInnerKey];
        [self drawYellowInner];
        [self spinMiddleLogoOnce];
    }
}

- (void)spinMiddleLogoOnce {
    CGFloat cockSpinDuration = 0.3;
    CGFloat fullRotationDuration = 0.6;
    CGFloat cockbackAngle = -M_PI*30/180; //30˚
    
    CABasicAnimation *cockBackAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    cockBackAnimation.duration = cockSpinDuration;
    cockBackAnimation.toValue = [NSNumber numberWithDouble:cockbackAngle];
    cockBackAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.sLogo.layer addAnimation:cockBackAnimation forKey:@"rotateCockBack"];
    
    CABasicAnimation *fullRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    fullRotationAnimation.beginTime = CACurrentMediaTime()+cockSpinDuration;
    fullRotationAnimation.duration = fullRotationDuration;
    fullRotationAnimation.toValue = [NSNumber numberWithDouble:2*M_PI];
    fullRotationAnimation.fromValue = [NSNumber numberWithFloat:cockbackAngle];
    fullRotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.sLogo.layer addAnimation:fullRotationAnimation forKey:@"rotateSpinMove"];
}

@end
