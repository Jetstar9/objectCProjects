//
//  CaptureControlView.h
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 8/19/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CaptureControlViewDelegate <NSObject>

-(void)capture:(id)sender;

@end

@interface CaptureControlView : UIView  {
    UIButton * button;
    id<CaptureControlViewDelegate> delegate;

}

@property(nonatomic,retain) UIButton * button;
@property(nonatomic,assign) id<CaptureControlViewDelegate> delegate;

-(void)allowCapture:(id)sender;

-(void)disallowCapture:(id)sender;

@end
