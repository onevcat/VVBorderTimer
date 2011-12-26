//
//  VVBorderTimerView.m
//
//  Created by onevcat on 11-12-22.
//
/*
 * Implement of VVBorderTimerView
 * https://github.com/onevcat/VVBorderTimer/
 *
 * BSD license follows (http://www.opensource.org/licenses/bsd-license.php)
 * 
 * Copyright (c) 2011 Wei Wang(onevcat) All Rights Reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of  source code  must retain  the above  copyright notice,
 * this list of  conditions and the following  disclaimer. Redistributions in
 * binary  form must  reproduce  the  above copyright  notice,  this list  of
 * conditions and the following disclaimer  in the documentation and/or other
 * materials  provided with  the distribution.  Neither the  name of  Wei
 * Wang nor the names of its contributors may be used to endorse or promote
 * products  derived  from  this  software  without  specific  prior  written
 * permission.  THIS  SOFTWARE  IS  PROVIDED BY  THE  COPYRIGHT  HOLDERS  AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
 * NOT LIMITED TO, THE IMPLIED  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A  PARTICULAR PURPOSE  ARE DISCLAIMED.  IN  NO EVENT  SHALL THE  COPYRIGHT
 * HOLDER OR  CONTRIBUTORS BE  LIABLE FOR  ANY DIRECT,  INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL DAMAGES (INCLUDING,  BUT NOT LIMITED
 * TO, PROCUREMENT  OF SUBSTITUTE GOODS  OR SERVICES;  LOSS OF USE,  DATA, OR
 * PROFITS; OR  BUSINESS INTERRUPTION)  HOWEVER CAUSED AND  ON ANY  THEORY OF
 * LIABILITY,  WHETHER  IN CONTRACT,  STRICT  LIABILITY,  OR TORT  (INCLUDING
 * NEGLIGENCE  OR OTHERWISE)  ARISING  IN ANY  WAY  OUT OF  THE  USE OF  THIS
 * SOFTWARE,   EVEN  IF   ADVISED  OF   THE  POSSIBILITY   OF  SUCH   DAMAGE.
 * 
 */

#define REFRESH_TIME 0.04
#define OFFSET_PIXEL 5
#define LINE_WIDTH _lineWidth

#import "VVBorderTimerView.h"

@implementation VVBorderTimerView
@synthesize delegate = _delegate;
@synthesize totalTime = _totalTime;
@synthesize colors = _colors;

-(void) setColors:(NSArray *)colors
{    
    NSMutableArray *arr = [NSMutableArray array];
    for (id obj in colors)
    {
        if ([obj isKindOfClass:[UIColor class]])
        {
            [arr addObject:(UIColor *)obj];
        }
    }
    if ([arr count] == 4)
    {
        _colors = [NSArray arrayWithArray:arr];
    }
    else
    {
        _colors = [NSArray arrayWithObjects:[UIColor blackColor],[UIColor blackColor],[UIColor blackColor],[UIColor blackColor],nil];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) updateUI
{
    if (_drawedTime >= _totalTime - 0.1)
    {
        _finished = YES;
        [_timer invalidate];
        _timer = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(timerViewDidFinishedTiming:)])
        {
            [self.delegate timerViewDidFinishedTiming:self];
        }
    }
    _drawedTime += REFRESH_TIME;
    [self setNeedsDisplay];
}

-(CGPoint) getCurrentPoint
{
    int totalBoundsPixel = 2 * ( self.bounds.size.width + self.bounds.size.height );
    float percent = _drawedTime / _totalTime;
    int currentPixel = totalBoundsPixel * percent;
    
    if (currentPixel < self.bounds.size.width)
    {
        return CGPointMake(currentPixel, 0);
    }
    else if (currentPixel < self.bounds.size.width + self.bounds.size.height)
    {
        return CGPointMake(self.bounds.size.width, currentPixel - self.bounds.size.width);
    }
    else if (currentPixel < 2 * self.bounds.size.width + self.bounds.size.height)
    {

        return CGPointMake(2 * self.bounds.size.width + self.bounds.size.height - currentPixel, self.bounds.size.height);
    }
    else if (currentPixel <= totalBoundsPixel)
    {
        return CGPointMake(0, totalBoundsPixel - currentPixel);
    }
    else
    {
        return CGPointMake(0, 0);
    }
}

-(int) sectionForPoint:(CGPoint)aPoint
{
    float cornerRadius = [self.delegate cornerRadius:self];
    if (cornerRadius < 0) 
        cornerRadius = 0;
    float shorterEdge = MIN(self.bounds.size.width,self.bounds.size.height);
    if (cornerRadius > shorterEdge / 2) 
        cornerRadius = shorterEdge / 2;

    if (aPoint.y == 0)
    {
        if (aPoint.x < cornerRadius)
        {
            return 0;
        }
        else if (aPoint.x < self.bounds.size.width - cornerRadius)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    else if (aPoint.x == self.bounds.size.width)
    {
        if (aPoint.y < cornerRadius)
        {
            return 3;
        }
        else if (aPoint.y < self.bounds.size.height - cornerRadius)
        {
            return 4;
        }
        else
        {
            return 5;
        }
    }
    else if (aPoint.y == self.bounds.size.height)
    {
        if (aPoint.x > self.bounds.size.width - cornerRadius)
        {
            return 6;
        }
        else if (aPoint.x > cornerRadius)
        {
            return 7;
        }
        else
        {
            return 8;
        }
    }
    else
    {
        if (aPoint.y > self.bounds.size.height - cornerRadius)
        {
            return 9;
        }
        else if (aPoint.y > cornerRadius)
        {
            return 10;
        }
        else
        {
            return 11;
        }
    }
    
    
}

-(float) angleForPonit:(CGPoint)aPoint radius:(float)r section:(int)section
{
    switch (section)
    {
        case 0:
        {
            float t = (r - aPoint.x) / r;
            return 3 * M_PI_2 - atan(t);
        }
            break;
        case 2:
        {
            float t = (r - self.bounds.size.width + aPoint.x) / r;
            return 3 * M_PI_2 + atan(t);
        }
            break;
        case 3:
        {
            float t = (r - aPoint.y) / r;
            return 2 * M_PI - atan(t);
        }
            break;
        case 5:
        {
            float t = (r - self.bounds.size.height + aPoint.y) / r;
            return atan(t);
        }
            break;
        case 6:
        {
            float t = (r - self.bounds.size.width + aPoint.x) / r;
            return M_PI_2 - atan(t);
        }
            break;
        case 8:
        {
            float t = (r - aPoint.x) / r;
            return M_PI_2 + atan(t);
        }
            break;
        case 9:
        {
            float t = (r - self.bounds.size.height + aPoint.y) / r;
            return M_PI - atan(t);
        }
            break;
        case 11:
        {
            float t = (r - aPoint.y) / r;
            return M_PI + atan(t);
        }
            break;
        default:
            break;
    }
    return 0;
}

-(void) drawArcFrom:(float)angel radius:(float)r section:(int)section inContext:(CGContextRef)context
{
//    UIGraphicsPushContext(context);
//	CGContextBeginPath(context);
    switch (section)
    {
        case 0:
            CGContextAddArc(context, r+LINE_WIDTH/2, r+LINE_WIDTH/2, r, angel, 3 * M_PI_2, NO);
            break;
        case 2:
            CGContextAddArc(context, self.bounds.size.width - r - LINE_WIDTH/2, r + LINE_WIDTH/2, r, angel, 7 * M_PI_4, NO);
            break;
        case 3:
            CGContextAddArc(context, self.bounds.size.width - r - LINE_WIDTH/2, r + LINE_WIDTH/2, r, angel, 2 * M_PI, NO);
            break;
        case 5:
            CGContextAddArc(context, self.bounds.size.width - r - LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2, r, angel, M_PI_4, NO);
            break;
        case 6:
            CGContextAddArc(context, self.bounds.size.width - r - LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2, r, angel, M_PI_2, NO);
            break;
        case 8:
            CGContextAddArc(context, r + LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2, r, angel, 3 * M_PI_4, NO);
            break;
        case 9:
            CGContextAddArc(context, r + LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2, r, angel, M_PI, NO);
            break;
        case 11:
            CGContextAddArc(context, r+LINE_WIDTH/2, r+LINE_WIDTH/2, r, angel, 5 * M_PI_4, NO);
            break;
        default:
            break;
    }

//	CGContextStrokePath(context);
//	UIGraphicsPopContext();
}

- (void) drawLineFrom:(CGPoint)aPoint radius:(float)r section:(int)section withContect:(CGContextRef)context
{
//    UIGraphicsPushContext(context);
//	CGContextBeginPath(context);
    
    switch (section)
    {
        case 1:
            CGContextMoveToPoint(context, aPoint.x, aPoint.y);
            CGContextAddLineToPoint(context, self.bounds.size.width - r, aPoint.y);
            break;
        case 4:
            CGContextMoveToPoint(context, aPoint.x, aPoint.y);
            CGContextAddLineToPoint(context, aPoint.x, self.bounds.size.height - r);
            break;
        case 7:
            CGContextMoveToPoint(context, aPoint.x, aPoint.y);
            CGContextAddLineToPoint(context, r, aPoint.y);
            break;
        case 10:
            CGContextMoveToPoint(context, aPoint.x, aPoint.y);
            CGContextAddLineToPoint(context, aPoint.x, r);
            break;
        default:
            break;
    }
    
    
//    CGContextStrokePath(context);
//	UIGraphicsPopContext();
}

-(UIColor *)colorBetweenColor:(UIColor *)aColor andColor:(UIColor *)anotherColor withPercent:(float)aPercent
{
    float r1,g1,b1,a1;
    float r2,g2,b2,a2;
	const CGFloat *aColors = CGColorGetComponents(aColor.CGColor);
	const CGFloat *anColors = CGColorGetComponents(anotherColor.CGColor);
	r1 = aColors[0];
	g1 = aColors[1];
	b1 = aColors[2];
	a1 = aColors[3];

	r2 = anColors[0];
	g2 = anColors[1];
	b2 = anColors[2];
	a2 = anColors[3];
	
    float r = r1 + (r2 - r1) * aPercent;
    float g = g1 + (g2 - g1) * aPercent;
    float b = b1 + (b2 - b1) * aPercent;
    if (r < 0.001 && g < 0.001 && b < 0.001)
    {
        return [UIColor blackColor];
    }
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{    
    if (_finished)
    {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, LINE_WIDTH);

    CGContextBeginPath(context);
    
    float r = [self.delegate cornerRadius:self];
    if (r < 0) 
        r = 0;
    float shorterEdge = MIN(self.bounds.size.width,self.bounds.size.height);
    if (r > shorterEdge / 2) 
        r = shorterEdge / 2;
    
    _lineWidth = [self.delegate lineWidth:self];
    
    CGPoint currentPoint = [self getCurrentPoint];
    int section = [self sectionForPoint:currentPoint];
    
    switch (section)
    {
        case 0:
        {
            [[self.colors objectAtIndex:0] setStroke];
            
            [self drawArcFrom:[self angleForPonit:currentPoint radius:r section:0] radius:r section:0 inContext:context];
            
            [self drawLineFrom:CGPointMake(r+LINE_WIDTH/2, LINE_WIDTH/2) radius:r section:1 withContect:context];
            
            [self drawArcFrom:3 * M_PI_2 radius:r section:2 inContext:context];
            [self drawArcFrom:7 * M_PI_4 radius:r section:3 inContext:context];
            
            [self drawLineFrom:CGPointMake(self.bounds.size.width - LINE_WIDTH/2, r + LINE_WIDTH/2) radius:r section:4 withContect:context];
            
            [self drawArcFrom:0 radius:r section:5 inContext:context];
            [self drawArcFrom:M_PI_4 radius:r section:6 inContext:context];
            
            [self drawLineFrom:CGPointMake(self.bounds.size.width - r - LINE_WIDTH/2, self.bounds.size.height - LINE_WIDTH/2) radius:r section:7 withContect:context];
            
            [self drawArcFrom:M_PI_2 radius:r section:8 inContext:context];
            [self drawArcFrom:3 * M_PI_4 radius:r section:9 inContext:context];
            
            [self drawLineFrom:CGPointMake(LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2) radius:r section:10 withContect:context];
            
            [self drawArcFrom:M_PI radius:r section:11 inContext:context];
        }
            break;
        
        case 1:
        {
            [[self.colors objectAtIndex:0] setStroke];
            [self drawLineFrom:CGPointMake(currentPoint.x, LINE_WIDTH/2) radius:r section:1 withContect:context];
            
            [self drawArcFrom:3 * M_PI_2 radius:r section:2 inContext:context];
            [self drawArcFrom:7 * M_PI_4 radius:r section:3 inContext:context];
            
            [self drawLineFrom:CGPointMake(self.bounds.size.width - LINE_WIDTH/2, r + LINE_WIDTH/2) radius:r section:4 withContect:context];
            
            [self drawArcFrom:0 radius:r section:5 inContext:context];
            [self drawArcFrom:M_PI_4 radius:r section:6 inContext:context];
            
            [self drawLineFrom:CGPointMake(self.bounds.size.width - r - LINE_WIDTH/2, self.bounds.size.height - LINE_WIDTH/2) radius:r section:7 withContect:context];
            
            [self drawArcFrom:M_PI_2 radius:r section:8 inContext:context];
            [self drawArcFrom:3 * M_PI_4 radius:r section:9 inContext:context];
            
            [self drawLineFrom:CGPointMake(LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2) radius:r section:10 withContect:context];
            
            [self drawArcFrom:M_PI radius:r section:11 inContext:context];
        }
            break;
        case 2:
        {
            float startAngle = 3 * M_PI_2;
            float currentAngle = [self angleForPonit:currentPoint radius:r section:section];
            float endAngle = 7 * M_PI_4;
            
            UIColor *finalColor = [self colorBetweenColor:[self.colors objectAtIndex:0] andColor:[self.colors objectAtIndex:1] withPercent:0.5];
            
            UIColor *currentColor = [self colorBetweenColor:[self.colors objectAtIndex:0] andColor:finalColor withPercent:(currentAngle - startAngle) / (endAngle - startAngle)];
            
            [currentColor setStroke];
            
            [self drawArcFrom:currentAngle radius:r section:2 inContext:context];
            [self drawArcFrom:7 * M_PI_4 radius:r section:3 inContext:context];
            
            [self drawLineFrom:CGPointMake(self.bounds.size.width - LINE_WIDTH/2, r + LINE_WIDTH/2) radius:r section:4 withContect:context];
            
            [self drawArcFrom:0 radius:r section:5 inContext:context];
            [self drawArcFrom:M_PI_4 radius:r section:6 inContext:context];
            
            [self drawLineFrom:CGPointMake(self.bounds.size.width - r - LINE_WIDTH/2, self.bounds.size.height - LINE_WIDTH/2) radius:r section:7 withContect:context];
            
            [self drawArcFrom:M_PI_2 radius:r section:8 inContext:context];
            [self drawArcFrom:3 * M_PI_4 radius:r section:9 inContext:context];
            
            [self drawLineFrom:CGPointMake(LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2) radius:r section:10 withContect:context];
            
            [self drawArcFrom:M_PI radius:r section:11 inContext:context];
        }
            break;
        case 3:
        {
            float startAngle = 7 * M_PI_4;
            float currentAngle = [self angleForPonit:currentPoint radius:r section:section];
            float endAngle = 2 * M_PI;
            
            UIColor *startColor = [self colorBetweenColor:[self.colors objectAtIndex:0] andColor:[self.colors objectAtIndex:1] withPercent:0.5];
            
            UIColor *currentColor = [self colorBetweenColor:startColor andColor:[self.colors objectAtIndex:1] withPercent:(currentAngle - startAngle) / (endAngle - startAngle)];
            
            [currentColor setStroke];
            
            [self drawArcFrom:currentAngle radius:r section:3 inContext:context];
            
            [self drawLineFrom:CGPointMake(self.bounds.size.width - LINE_WIDTH/2, r + LINE_WIDTH/2) radius:r section:4 withContect:context];
            
            [self drawArcFrom:0 radius:r section:5 inContext:context];
            [self drawArcFrom:M_PI_4 radius:r section:6 inContext:context];
            
            [self drawLineFrom:CGPointMake(self.bounds.size.width - r - LINE_WIDTH/2, self.bounds.size.height - LINE_WIDTH/2) radius:r section:7 withContect:context];
            
            [self drawArcFrom:M_PI_2 radius:r section:8 inContext:context];
            [self drawArcFrom:3 * M_PI_4 radius:r section:9 inContext:context];
            
            [self drawLineFrom:CGPointMake(LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2) radius:r section:10 withContect:context];
            
            [self drawArcFrom:M_PI radius:r section:11 inContext:context];
        }
            break;
        case 4:
        {
            [[self.colors objectAtIndex:1] setStroke];
            
            [self drawLineFrom:CGPointMake(self.bounds.size.width - LINE_WIDTH / 2, currentPoint.y) radius:r section:4 withContect:context];
            
            [self drawArcFrom:0 radius:r section:5 inContext:context];
            [self drawArcFrom:M_PI_4 radius:r section:6 inContext:context];
            
            [self drawLineFrom:CGPointMake(self.bounds.size.width - r - LINE_WIDTH/2, self.bounds.size.height - LINE_WIDTH/2) radius:r section:7 withContect:context];
            
            [self drawArcFrom:M_PI_2 radius:r section:8 inContext:context];
            [self drawArcFrom:3 * M_PI_4 radius:r section:9 inContext:context];
            
            [self drawLineFrom:CGPointMake(LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2) radius:r section:10 withContect:context];
            
            [self drawArcFrom:M_PI radius:r section:11 inContext:context];
        }
            break;
        case 5:
        {
            float startAngle = 0;
            float currentAngle = [self angleForPonit:currentPoint radius:r section:section];
            float endAngle = M_PI_4;
            
            UIColor *finalColor = [self colorBetweenColor:[self.colors objectAtIndex:1] andColor:[self.colors objectAtIndex:2] withPercent:0.5];
            
            UIColor *currentColor = [self colorBetweenColor:[self.colors objectAtIndex:1] andColor:finalColor withPercent:(currentAngle - startAngle) / (endAngle - startAngle)];
            
            [currentColor setStroke];
            
            [self drawArcFrom:currentAngle radius:r section:5 inContext:context];
            [self drawArcFrom:M_PI_4 radius:r section:6 inContext:context];
            
            [self drawLineFrom:CGPointMake(self.bounds.size.width - r - LINE_WIDTH/2, self.bounds.size.height - LINE_WIDTH/2) radius:r section:7 withContect:context];
            
            [self drawArcFrom:M_PI_2 radius:r section:8 inContext:context];
            [self drawArcFrom:3 * M_PI_4 radius:r section:9 inContext:context];
            
            [self drawLineFrom:CGPointMake(LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2) radius:r section:10 withContect:context];
            
            [self drawArcFrom:M_PI radius:r section:11 inContext:context];
        }
            break;
        case 6:
        {
            float startAngle = M_PI_4;
            float currentAngle = [self angleForPonit:currentPoint radius:r section:section];
            float endAngle = M_PI_2;
            
            UIColor *startColor = [self colorBetweenColor:[self.colors objectAtIndex:1] andColor:[self.colors objectAtIndex:2] withPercent:0.5];
            
            UIColor *currentColor = [self colorBetweenColor:startColor andColor:[self.colors objectAtIndex:2] withPercent:(currentAngle - startAngle) / (endAngle - startAngle)];
            
            [currentColor setStroke];
            
            [self drawArcFrom:currentAngle radius:r section:6 inContext:context];
            
            [self drawLineFrom:CGPointMake(self.bounds.size.width - r - LINE_WIDTH/2, self.bounds.size.height - LINE_WIDTH/2) radius:r section:7 withContect:context];
            
            [self drawArcFrom:M_PI_2 radius:r section:8 inContext:context];
            [self drawArcFrom:3 * M_PI_4 radius:r section:9 inContext:context];
            
            [self drawLineFrom:CGPointMake(LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2) radius:r section:10 withContect:context];
            
            [self drawArcFrom:M_PI radius:r section:11 inContext:context];
        }
            break;
        case 7:
        {
            [[self.colors objectAtIndex:2] setStroke];
            
            [self drawLineFrom:CGPointMake(currentPoint.x, self.bounds.size.height - LINE_WIDTH/2) radius:r section:7 withContect:context];
            
            [self drawArcFrom:M_PI_2 radius:r section:8 inContext:context];
            [self drawArcFrom:3 * M_PI_4 radius:r section:9 inContext:context];
            
            [self drawLineFrom:CGPointMake(LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2) radius:r section:10 withContect:context];
            
            [self drawArcFrom:M_PI radius:r section:11 inContext:context];
        }
            break;
        case 8:
        {
            float startAngle = M_PI_2;
            float currentAngle = [self angleForPonit:currentPoint radius:r section:section];
            float endAngle = 3 * M_PI_4;
            
            UIColor *finalColor = [self colorBetweenColor:[self.colors objectAtIndex:2] andColor:[self.colors objectAtIndex:3] withPercent:0.5];
            
            UIColor *currentColor = [self colorBetweenColor:[self.colors objectAtIndex:2] andColor:finalColor withPercent:(currentAngle - startAngle) / (endAngle - startAngle)];
            
            [currentColor setStroke];
            
            [self drawArcFrom:currentAngle radius:r section:8 inContext:context];
            [self drawArcFrom:3 * M_PI_4 radius:r section:9 inContext:context];
            
            [self drawLineFrom:CGPointMake(LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2) radius:r section:10 withContect:context];
            
            [self drawArcFrom:M_PI radius:r section:11 inContext:context];
        }
            break;
        case 9:
        {
            float startAngle = M_PI_4;
            float currentAngle = [self angleForPonit:currentPoint radius:r section:section];
            float endAngle = M_PI_2;
            
            UIColor *startColor = [self colorBetweenColor:[self.colors objectAtIndex:2] andColor:[self.colors objectAtIndex:3] withPercent:0.5];
            
            UIColor *currentColor = [self colorBetweenColor:startColor andColor:[self.colors objectAtIndex:3] withPercent:(currentAngle - startAngle) / (endAngle - startAngle)];
            
            [currentColor setStroke];
            
            [self drawArcFrom:[self angleForPonit:currentPoint radius:r section:9] radius:r section:9 inContext:context];
            
            [self drawLineFrom:CGPointMake(LINE_WIDTH/2, self.bounds.size.height - r - LINE_WIDTH/2) radius:r section:10 withContect:context];
            
            [self drawArcFrom:M_PI radius:r section:11 inContext:context];
        }
            break;
        case 10:
        {
            [[self.colors objectAtIndex:3] setStroke];
            
            [self drawLineFrom:CGPointMake(LINE_WIDTH/2, currentPoint.y) radius:r section:10 withContect:context];
            
            [self drawArcFrom:M_PI radius:r section:11 inContext:context];
        }
            break;
        case 11:
        {
            [[self.colors objectAtIndex:3] setStroke];
            
            [self drawArcFrom:[self angleForPonit:currentPoint radius:r section:11] radius:r section:11 inContext:context];
        }
        default:
            break;
    }
    
    CGContextStrokePath(context);
}


-(void) start
{
    if (!_colors)
    {
        self.colors = nil;
    }
    
    [_timer invalidate];
    _finished = NO;
    _drawedTime = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
}

-(void) stop
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    }
    _drawedTime = self.totalTime + 1;
}

-(void) pause
{
    [_timer invalidate];
    _timer = nil;
}

-(void)resume
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    }
}

-(void) dealloc
{
    _timer = nil;
    self.delegate = nil;
    _colors = nil;
}

@end
