//
//  VVBorderTimerDemoViewController.h
//
//  Created by onevcat on 11-12-22.
//
/*
 * Header of VVBorderTimerViewDemoViewController
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
#import "VVBorderTimerView.h"
@interface VVBorderTimerDemoViewController : UIViewController<VVBorderTimerViewDelegate>
{
    VVBorderTimerView *                                     _borderTimerView;
    UISlider *                                                        _sliderRadius;
    UISlider *                                                        _sliderWidth;
    UILabel *                                                        _lblRadius;
    UILabel *                                                        _lblWidth;
}

@property (nonatomic, retain) IBOutlet VVBorderTimerView* borderTimerView;
@property (nonatomic, retain) IBOutlet UISlider *sliderRadius;
@property (nonatomic, retain) IBOutlet UISlider *sliderWidth;
@property (nonatomic, retain) IBOutlet UILabel *lblRadius;
@property (nonatomic, retain) IBOutlet UILabel *lblWidth;

-(IBAction)radiusChanged:(id)sender;
-(IBAction)widthChanged:(id)sender;

-(IBAction)btnStartPressed:(id)sender;
-(IBAction)btnStopPressed:(id)sender;
-(IBAction)btnPausePressed:(id)sender;
-(IBAction)btnResumePressed:(id)sender;

@end
