//
//  IBProgressBar.h
//  iBirds
//
//  Created by Samuel Westrich on 9/28/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBProgressBar : UIView {
    CGFloat progress;
	UIColor * tintColor;
    NSTimer * progressTimer;
    CGFloat targetProgress;
}

- (void) setTintColor: (UIColor *) aColor;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
@property(nonatomic,assign) CGFloat progress;
@property(nonatomic,retain) UIColor * tintColor;

@end
