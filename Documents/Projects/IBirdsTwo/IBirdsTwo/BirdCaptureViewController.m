//
//  BirdCaptureViewController.m
//  iBirds
//
//  Created by Samuel Westrich on 10/18/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "BirdCaptureViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "BirdCaughtViewController.h"
#import "OverlayView.h"
#import "IBConnector.h"
#import "Environment.h"
#import "NetworkNotifications.h"
#import "BirdCage.h"

#define CAMERA_TRANSFORM                    1.255

@interface BirdCaptureViewController() 

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller

                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   
                                                   UINavigationControllerDelegate>) delegate;
@end

@implementation BirdCaptureViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(birdsReceived:)
												 name:n_ClosestBirdsReceived object:nil];
    

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[IBConnector sharedInstance] closestBirdsForUser:[[Environment sharedInstance] currentUser]];
}


-(void)birdsReceived:(NSNotification*)notification {
    NSArray * closestBirds = [[notification userInfo] objectForKey:@"closeBirds"];
    [[BirdCage sharedInstance] addBirds:closestBirds];
    [self startCameraControllerFromViewController: self
     
                                    usingDelegate: self];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller

                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   
                                                   UINavigationControllerDelegate>) delegate {
    
    
    
    if (([UIImagePickerController isSourceTypeAvailable:
          
          UIImagePickerControllerSourceTypeCamera] == NO)
        
        || (delegate == nil)
        
        || (controller == nil))
        
        return NO;
    
    
    
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //cameraUI.wantsFullScreenLayout = TRUE;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(CAMERA_TRANSFORM, CAMERA_TRANSFORM);
    //CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 20.0f);
    cameraUI.cameraViewTransform = transform;
    //
    // Displays a control that allows the user to choose picture or
    
    // movie capture, if both are available:
    
    cameraUI.mediaTypes =
    
    [UIImagePickerController availableMediaTypesForSourceType:
     
     UIImagePickerControllerSourceTypeCamera];
    
    cameraUI.showsCameraControls = FALSE;
    
    // Hides the controls for moving & scaling pictures, or for
    
    // trimming movies. To instead show the controls, use YES.
    
    cameraUI.allowsEditing = NO;
    
    
    
    cameraUI.delegate = delegate;
    
    OverlayView * overView = [[OverlayView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    overView.controlView.imagePickerController = cameraUI;
    cameraUI.cameraOverlayView = overView;
    [overView.aRView startAnimation];
    //[overlay start];
    
    
    [controller presentModalViewController:cameraUI animated: YES];
    //[controller presentModalViewController: overlayController animated: YES];
    return YES;
    
}


// For responding to the user tapping Cancel.

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    
    
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
    
    [picker release];
    
}



// For responding to the user accepting a newly-captured picture or movie

- (void) imagePickerController: (UIImagePickerController *) picker

 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    BirdCaughtViewController * birdCaughtViewController = [[BirdCaughtViewController alloc] initWithNibName:@"BirdCaughtViewController" bundle:nil];
    [self.navigationController pushViewController:birdCaughtViewController animated:FALSE];
    [birdCaughtViewController release];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        
        UIImage *originalImage, *editedImage, *imageToSave;
        
        
        
        // Handle a still image capture
        
        if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
            
            == kCFCompareEqualTo) {
            
            
            
            editedImage = (UIImage *) [info objectForKey:
                                       
                                       UIImagePickerControllerEditedImage];
            
            originalImage = (UIImage *) [info objectForKey:
                                         
                                         UIImagePickerControllerOriginalImage];
            
            
            
            if (editedImage) {
                
                imageToSave = editedImage;
                
            } else {
                
                imageToSave = originalImage;
                
            }
            
            CGSize newSize = imageToSave.size;
            UIGraphicsBeginImageContext( newSize );
            
            // Use existing opacity as is
            [imageToSave drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            OverlayView * oV = (OverlayView *)picker.cameraOverlayView;
            UIImage * image = [oV.aRView eaglViewToUIImage];
            [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            // Apply supplied opacity
            
            UIGraphicsEndImageContext();
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, (newSize.height - newSize.width) / 2, newSize.width, newSize.width));
            // or use the UIImage wherever you like
            
            [birdCaughtViewController setTempImage:[UIImage imageWithCGImage:imageRef]];
            
        }
        
        
        
        // Handle a movie capture
        
        if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
            
            == kCFCompareEqualTo) {
            
            
            
            NSString *moviePath = [[info objectForKey:
                                    
                                    UIImagePickerControllerMediaURL] path];
            
            
            
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                
                UISaveVideoAtPathToSavedPhotosAlbum (
                                                     
                                                     moviePath, nil, nil, nil);
                
            }
            
        }
        
        
        
        [picker dismissModalViewControllerAnimated: YES];
        
        [picker release];
    } else {
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        
        UIImage *originalImage, *editedImage, *imageToSave;
        
        
        
        // Handle a still image capture
        
        if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
            
            == kCFCompareEqualTo) {
            
            
            
            editedImage = (UIImage *) [info objectForKey:
                                       
                                       UIImagePickerControllerEditedImage];
            
            originalImage = (UIImage *) [info objectForKey:
                                         
                                         UIImagePickerControllerOriginalImage];
            
            
            
            if (editedImage) {
                
                imageToSave = editedImage;
                
            } else {
                
                imageToSave = originalImage;
                
            }
            
            
            
            // Save the new image (original or edited) to the Camera Roll
            
            //self.imageToUse = imageToSave;
            
        }
        
        
        
        [picker dismissModalViewControllerAnimated: YES];
        
        [picker release];
        
    }
    
}


@end
