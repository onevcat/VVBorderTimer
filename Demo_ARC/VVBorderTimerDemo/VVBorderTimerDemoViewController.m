//
//  VVBorderTimerDemoViewController.m
//
//  Created by onevcat on 11-12-22.
//
/*
 * Implement of VVBorderTimerViewDemoViewController
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

#import "VVBorderTimerDemoViewController.h"

@implementation VVBorderTimerDemoViewController

@synthesize borderTimerView = _borderTimerView;
@synthesize sliderRadius = _sliderRadius;
@synthesize sliderWidth = _sliderWidth;
@synthesize lblRadius = _lblRadius;
@synthesize lblWidth = _lblWidth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sliderRadius.maximumValue = ceil( MIN(self.borderTimerView.frame.size.width, self.borderTimerView.frame.size.height) / 2 );
    self.sliderRadius.value = 50;
    self.lblRadius.text = [NSString stringWithFormat:@"%d",(int)self.sliderRadius.value];
    
    self.sliderWidth.maximumValue = 20;
    self.sliderWidth.value = 10;
    self.lblWidth.text = [NSString stringWithFormat:@"%d",(int)self.sliderWidth.value];
    
    //Setup the timer
    self.borderTimerView.delegate =self;
    
    //I want to count 10sec
    self.borderTimerView.totalTime = 10;
    
    //Green -> Yellow -> Orange -> Red
    UIColor *color0 = [UIColor greenColor];
    UIColor *color1 = [UIColor yellowColor];
    UIColor *color2 = [UIColor colorWithRed:1.0 green:140.0/255.0 blue:16.0/255.0 alpha:1.0];
    UIColor *color3 = [UIColor redColor];
    self.borderTimerView.colors = [NSArray arrayWithObjects:color0,color1,color2,color3,nil];
    
    //Start the timer
    [self.borderTimerView start];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.borderTimerView = nil;
    self.sliderRadius = nil;
}

-(void) dealloc
{
    self.borderTimerView = nil;
    self.sliderRadius = nil;
}

#pragma mark - IBActions
-(IBAction)radiusChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    self.lblRadius.text = [NSString stringWithFormat:@"%d",(int)slider.value];
    [self.borderTimerView setNeedsDisplay];
}

-(IBAction)widthChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    self.lblWidth.text = [NSString stringWithFormat:@"%d",(int)slider.value];
    [self.borderTimerView setNeedsDisplay];
}

-(IBAction)btnStartPressed:(id)sender
{
    [self.borderTimerView start];
}
-(IBAction)btnStopPressed:(id)sender
{
    [self.borderTimerView stop];
}
-(IBAction)btnPausePressed:(id)sender
{
    [self.borderTimerView pause];
}
-(IBAction)btnResumePressed:(id)sender
{
    [self.borderTimerView resume];
}

#pragma mark - Implement of VVBorderTimerViewDelegate
-(float) cornerRadius:(VVBorderTimerView *)requestor
{
    return self.sliderRadius.value;
}

-(float) lineWidth:(VVBorderTimerView *)requestor
{
    return self.sliderWidth.value;
}

-(void) timerViewDidFinishedTiming:(VVBorderTimerView *)aTimerView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VVBorderTimer" message:@"Times Up" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}



@end
