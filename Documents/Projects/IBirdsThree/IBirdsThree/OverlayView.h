//
//  OverlayView.h
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 8/19/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAGLView.h"
#import "ControlsView.h"

@interface OverlayView : UIView {
    EAGLView * aRView;
    ControlsView * controlView;
}

@property (nonatomic,retain) EAGLView * aRView;
@property (nonatomic,retain) ControlsView * controlView;

@end
