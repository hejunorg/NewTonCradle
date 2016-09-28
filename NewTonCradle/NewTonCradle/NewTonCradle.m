//
//  NewTonCradle.m
//  NewTonCradle
//
//  Created by hejun on 9/20/16.
//  Copyright © 2016 teamleader. All rights reserved.
//

#import "NewTonCradle.h"

@interface NewTonCradle()<CAAnimationDelegate>

/** 宽度 */
@property (nonatomic, assign) CGFloat width;
/** 高度 */
@property (nonatomic, assign) CGFloat height;
/** 左边的竖线 */
@property (nonatomic, weak) CAShapeLayer *leftLine;
/** 左边的圆 */
@property (nonatomic, weak) CAShapeLayer *leftCycle;
/** 左边的旋转路径 */
@property (nonatomic, assign) CGMutablePathRef leftPath;
/** 右边的竖线 */
@property (nonatomic, weak) CAShapeLayer *rightLine;
/** 右边的圆 */
@property (nonatomic, weak) CAShapeLayer *rightCycle;
/** 右边的旋转路径 */
@property (nonatomic, assign) CGMutablePathRef rightPath;
/** 图层列表 */
@property (nonatomic, strong) NSMutableArray *layerArray;
/** 左边线的动画 */
@property (nonatomic, weak) CABasicAnimation *leftBaseAnimation;
/** 右边线的动画 */
@property (nonatomic, weak) CABasicAnimation *rightBaseAnimation;
/** 左边圆的动画 */
@property (nonatomic, weak) CAKeyframeAnimation *leftKeyFrameAnimation;
/** 右边圆的动画 */
@property (nonatomic, weak) CAKeyframeAnimation *rightKeyFrameAnimation;
@property (nonatomic, copy) void(^animationFinishBlock)(CAAnimation *animation);


@end

@implementation NewTonCradle

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_width = self.frame.size.width;
		_height = self.frame.size.height;
		
		[self showAnimation];
		
	}
	
	return self;
}

- (void)showAnimation {
	[self createLayer];
	[self leftAnimation];
	
	__weak typeof(self) weakSelf = self;
	
	self.animationFinishBlock = ^(CAAnimation *animation) {
		if ([[animation valueForKey:@"left"] isEqualToString:@"left"]) {
			//左边动画结束，开始右边动画
			[weakSelf rightAnimation];
		} else if ([[animation valueForKey:@"right"] isEqualToString:@"right"]) {
			//右边的动画结束，开始左边的动画
			[weakSelf leftAnimation];
		}
	};
}

- (void)hideAnimation {
	self.animationFinishBlock = ^(CAAnimation *animation) {
		
	};
	
	for (CALayer *layer in self.layerArray) {
		[layer removeFromSuperlayer];
	}
}

/**
 * 结束动画代理
 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	self.animationFinishBlock(anim);
}

/**
 * 添加左边动画
 */
- (void)leftAnimation {
	//左边线条动画
	CABasicAnimation *leftBaseAnimation = [CABasicAnimation animation];
	self.leftBaseAnimation = leftBaseAnimation;
	self.leftBaseAnimation.keyPath = @"transform.rotation.z";
	self.leftBaseAnimation.duration = 0.4;
	self.leftBaseAnimation.fromValue = [NSNumber numberWithFloat:0];
	self.leftBaseAnimation.toValue = [NSNumber numberWithFloat:M_PI_4 / 2];
	self.leftBaseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	self.leftBaseAnimation.autoreverses = YES;
	self.leftBaseAnimation.delegate = self;
	self.leftBaseAnimation.fillMode = kCAFillModeForwards;
	[self.leftLine addAnimation:self.leftBaseAnimation forKey:@"leftBaseAnimation"];
	
	//左边的圆
	self.leftPath = CGPathCreateMutable();
	CGPathAddArc(self.leftPath, nil, 25, 10, 60, M_PI_2, M_PI_2 + M_PI_4 / 2, NO);
	CAKeyframeAnimation *leftKeyFrameAnimation = [CAKeyframeAnimation animation];
	self.leftKeyFrameAnimation = leftKeyFrameAnimation;
	self.leftKeyFrameAnimation.keyPath = @"position";
	self.leftKeyFrameAnimation.calculationMode = kCAAnimationCubic;
	self.leftKeyFrameAnimation.path = self.leftPath;
	self.leftKeyFrameAnimation.duration = 0.4f;
	self.leftKeyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	self.leftKeyFrameAnimation.autoreverses = YES;
	self.leftKeyFrameAnimation.fillMode = kCAFillModeForwards;
	self.leftKeyFrameAnimation.delegate = self;
	[self.leftKeyFrameAnimation setValue:@"left" forKey:@"left"];
	[self.leftCycle addAnimation:self.leftKeyFrameAnimation forKey:@"leftKeyFrameAnimation"];
}

/**
 * 添加右边的动画
 */
- (void)rightAnimation {
	//右边的线动画
	CABasicAnimation *rightBaseAnimation = [CABasicAnimation animation];
	self.rightBaseAnimation = rightBaseAnimation;
	self.rightBaseAnimation.keyPath = @"transform.rotation.z";
	self.rightBaseAnimation.duration = 0.4f;
	self.rightBaseAnimation.fromValue = [NSNumber numberWithFloat:0];
	self.rightBaseAnimation.toValue = [NSNumber numberWithFloat:-M_PI_4 / 2];
	self.rightBaseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	self.rightBaseAnimation.autoreverses = YES;
	self.rightBaseAnimation.fillMode = kCAFillModeForwards;
	self.rightBaseAnimation.delegate = self;
	[self.rightLine addAnimation:self.rightBaseAnimation forKey:@"rightBaseAnimation"];
	
	//右边的圆动画
	self.rightPath = CGPathCreateMutable();
	CGPathAddArc(self.rightPath, nil, 75, 10, 60, M_PI_2, M_PI_2 - M_PI_4 / 2, YES);
	CAKeyframeAnimation *rightKeyFrameAnimation = [CAKeyframeAnimation animation];
	self.rightKeyFrameAnimation = rightKeyFrameAnimation;
	self.rightKeyFrameAnimation.keyPath = @"position";
	self.rightKeyFrameAnimation.calculationMode = kCAAnimationCubic;
	self.rightKeyFrameAnimation.path = self.rightPath;
	self.rightKeyFrameAnimation.duration = 0.4f;
	self.rightKeyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	self.rightKeyFrameAnimation.autoreverses = YES;
	self.rightKeyFrameAnimation.fillMode = kCAFillModeForwards;
	self.rightKeyFrameAnimation.delegate = self;
	[self.rightKeyFrameAnimation setValue:@"right" forKey:@"right"];
	[self.rightCycle addAnimation:self.rightKeyFrameAnimation forKey:@"rightKeyFrameAnimation"];
}

/**
 * 画左边的线
 */
- (void)createLeftLine {
	CAShapeLayer *leftLine = [CAShapeLayer layer];
	self.leftLine = leftLine;
	
	CGMutablePathRef leftPath = CGPathCreateMutable();
	CGPathMoveToPoint(leftPath, nil, 0, 0);
	CGPathAddLineToPoint(leftPath, nil, 0, 60);
	self.leftLine.path = leftPath;
	
	self.leftLine.frame = CGRectMake(25, 10, 100, 100);
	self.leftLine.position = CGPointMake(25, 10);
	self.leftLine.anchorPoint = CGPointMake(0, 0);
	self.leftLine.strokeColor = [UIColor blueColor].CGColor;
	self.leftLine.lineCap = kCALineCapRound;
	self.leftLine.lineWidth = 2;
	[self setShadow:self.leftLine];
	[self.layer addSublayer:self.leftLine];
	[self.layerArray addObject:self.leftLine];
}

/**
 * 画左边的圆
 */
- (void)createLeftCycle {
	CAShapeLayer *leftCycle = [CAShapeLayer layer];
	self.leftCycle = leftCycle;
	
	CGMutablePathRef cyclePath = CGPathCreateMutable();
	CGPathAddArc(cyclePath, nil, 5, 5, 5, 0, M_PI * 2, YES);
	self.leftCycle.path = cyclePath;
	self.leftCycle.fillColor = [UIColor brownColor].CGColor;
	self.leftCycle.frame = CGRectMake(20, 65, 10, 10);
	self.leftCycle.position = CGPointMake(25, 70);
//	[self setShadow:self.leftCycle];
	
	[self.layer addSublayer:self.leftCycle];
	[self.layerArray addObject:self.layer];
}

/**
 * 画右边的线
 */
- (void)createRightLine {
	CAShapeLayer *rightLine = [CAShapeLayer layer];
	self.rightLine = rightLine;
	
	CGMutablePathRef rightPath = CGPathCreateMutable();
	CGPathMoveToPoint(rightPath, nil, 0, 0);
	CGPathAddLineToPoint(rightPath, nil, 0, 60);
	self.rightLine.path = rightPath;
	self.rightLine.lineCap = kCALineCapRound;
	self.rightLine.lineWidth = 2;
	self.rightLine.strokeColor = [UIColor blueColor].CGColor;
	self.rightLine.frame = CGRectMake(75, 10, 100, 100);
	self.rightLine.position = CGPointMake(75, 10);
	self.rightLine.anchorPoint = CGPointMake(0, 0);
	[self.layer addSublayer:self.rightLine];
	[self.layerArray addObject:self.layer];
}

/**
 * 画右边的圆
 */
- (void)createRightCycle {
	CAShapeLayer *rightCycle = [CAShapeLayer layer];
	self.rightCycle = rightCycle;
	
	CGMutablePathRef rightPath = CGPathCreateMutable();
	CGPathAddArc(rightPath, nil, 5, 5, 5, 0, M_PI * 2, YES);
	self.rightCycle.path = rightPath;
	self.rightCycle.fillColor = [UIColor brownColor].CGColor;
	self.rightCycle.frame = CGRectMake(70, 65, 10, 10);
	self.rightCycle.position = CGPointMake(75, 70);
	[self setShadow:self.rightCycle];
	[self.layer addSublayer:self.rightCycle];
	[self.layerArray addObject:self.rightCycle];
}

/**
 * 创建中间四条线及四个圆
 */
- (void)createLayer {
	for (int i = 1; i < 5; i++) {
		CAShapeLayer *layer = [self createLineWithX:i * 10 + 25 andY:10];
		CAShapeLayer *cycleLayer = [self createCycleWithX:i * 10 + 25 andY:70];
		[self.layer addSublayer:layer];
		[self.layer addSublayer:cycleLayer];
		[self.layerArray addObject:layer];
		[self.layerArray addObject:cycleLayer];
	}
	[self createLeftLine];
	[self createLeftCycle];
	
	[self createRightLine];
	[self createRightCycle];
	
	[self createTopLine];
}

/**
 * 画最上边的横线
 */
- (void)createTopLine {
	CAShapeLayer *topLine = [CAShapeLayer layer];
	
	CGMutablePathRef topPath = CGPathCreateMutable();
	CGPathMoveToPoint(topPath, nil, 10, 10);
	CGPathAddLineToPoint(topPath, nil, 90, 10);
	topLine.path = topPath;
	topLine.strokeColor = [UIColor brownColor].CGColor;
	topLine.lineCap = kCALineCapRound;
	topLine.lineWidth = 5;
	[self setShadow:topLine];
	[self.layer addSublayer:topLine];
	[self.layerArray addObject:topLine];
}

/**
 * 创建中间的线条
 */
- (CAShapeLayer *)createLineWithX:(CGFloat)x andY:(CGFloat)y {
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, nil, 0, 0);
	CGPathAddLineToPoint(path, nil, 0, 60);
	
	//设置线路径
	shapeLayer.path = path;
	//设置frame
	shapeLayer.frame = CGRectMake(x, y, 2, 70);
	//设置线宽
	shapeLayer.lineWidth = 2;
	//设置线端点样式
	shapeLayer.lineCap = kCALineCapRound;
	//设置线填充色
	shapeLayer.strokeColor = [UIColor blueColor].CGColor;
	//设置阴影
	[self setShadow:shapeLayer];
	
	return shapeLayer;
}

/**
 * 创建中间圆
 */
- (CAShapeLayer *)createCycleWithX:(CGFloat)x andY:(CGFloat)y {
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	
	CGMutablePathRef path = CGPathCreateMutable();
	//画圆
	CGPathAddArc(path, nil, 0, 0, 5, 0, M_PI * 2, YES);
	//设置路径
	shapeLayer.path = path;
	//设置frame
	shapeLayer.frame = CGRectMake(x, y, 10, 10);
	//填充色
	shapeLayer.fillColor = [UIColor brownColor].CGColor;
	//设置阴影
	[self setShadow:shapeLayer];
	
	return shapeLayer;
}

/**
 * 设置阴影
 */
-(void)setShadow:(CALayer *)layer {
	layer.cornerRadius = 5;
	layer.shadowColor = [UIColor blackColor].CGColor;
	layer.shadowOffset = CGSizeMake(5, 3);
	layer.shadowOpacity = 3.0f;
}

#pragma mark - lazyload
- (NSMutableArray *)layerArray {
	if (_layerArray == nil) {
		_layerArray = [NSMutableArray array];
	}
	return _layerArray;
}

//自身的宽高
CGFloat _height;
CGFloat _width;

//左边的竖线,左边的圆,左边的旋转路径
CAShapeLayer * _leftLine;
CAShapeLayer * _leftCircle;
CGMutablePathRef  _leftPath;

//右边的竖线,右边的圆,右边的旋转路径
CAShapeLayer * _rightLine;
CAShapeLayer * _rightCircle;
CGMutablePathRef  _rightPath;

//左边的动画
CABasicAnimation * _leftBaseAnimation;
CABasicAnimation * _rightBaseAnimation;

//右边的动画
CAKeyframeAnimation * _leftKeyframeAnimation;
CAKeyframeAnimation * _rightKeyframeAnimation;

//动画结束调用的block
void(^animationFinishBlock)(CAAnimation * animation);

//存放所有图层的数组
NSMutableArray  * _array;

@end
