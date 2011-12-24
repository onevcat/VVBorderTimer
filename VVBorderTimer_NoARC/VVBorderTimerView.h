//
//  VVBorderTimerView.h
//
//  Created by onevcat on 11-12-22.
//
/*
 * Header of VVBorderTimerView
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

#import <UIKit/UIKit.h>
@class VVBorderTimerView;

@protocol VVBorderTimerViewDelegate<NSObject>

@required
//Delegate should return the cornerRadius in pixel for the requstor.
-(float) cornerRadius:(VVBorderTimerView *)requestor;

//Delegate should return the line width in pixel for the requstor.
-(float) lineWidth:(VVBorderTimerView *)requestor;

@optional
//aTimerView's timing finished with no interrupt
-(void) timerViewDidFinishedTiming:(VVBorderTimerView *)aTimerView;

@end

@interface VVBorderTimerView : UIView
{
    id<VVBorderTimerViewDelegate>                               _delegate;

    float                                                                             _drawedTime;
    float                                                                             _totalTime;
    float                                                                             _lineWidth;
    
    NSTimer *                                                                     _timer;
    NSArray *                                                                     _colors;
    BOOL                                                                           _finished;
}

//Delegate of the view for information as cornerRadius, lineWidth and finishing reporting
@property (nonatomic, assign) id<VVBorderTimerViewDelegate> delegate;

//time before the timer counts a whole loop. Set it to the time you want to count
@property (nonatomic, assign) float totalTime;

//Colors the timer should changed. This array should be contains four UIColor objects. Each color will be used for one line of the border and a gradual transition will be taken in the corner. If your set this property wrong, a default black color will be used for all lines.
@property (nonatomic, retain) NSArray *colors;

//Start the timer from very begining
-(void) start;

//Stop the timer and clean its content
-(void) stop;

//Pause the timer and hold its content
-(void) pause;

//Resume from last pause
-(void) resume;

@end
