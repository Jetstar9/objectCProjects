//
//  BirdCaughtViewController.h
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 8/23/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BirdCaughtViewController : UIViewController {
    UIImageView * pictureImageView;
    UIImage * tempImage;
}

@property(nonatomic,retain) IBOutlet UIImageView * pictureImageView;
@property(nonatomic,retain) UIImage * tempImage;

@end
