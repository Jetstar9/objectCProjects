//
//  TextInputCell.m
//  iBirds
//
//  Created by Samuel Westrich on 9/19/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "TextInputCell.h"
#import <UIKit/UIKit.h>
#import "AdyNumberTextField.h"

@implementation TextInputCell

@synthesize textField;
@synthesize isTextField;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// Initialization code
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.font = [UIFont fontWithName:@"GillSans-Bold" size:17];
		self.textLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.8];
		self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.textLabel.textColor = [UIColor blackColor];
		/*self.detailTextLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.font = [UIFont fontWithName:@"GillSans-Bold" size:17];
		self.detailTextLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.8];
		self.detailTextLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.detailTextLabel.textColor = [UIColor colorWithWhite:0.78 alpha:1.0];//[UIColor colorWithRed:.22 green:.33 blue:.53 alpha:1.0];
		self.detailTextLabel.textAlignment = UITextAlignmentLeft;*/
		self.opaque = YES;
		self.backgroundView.opaque = YES;
		self.backgroundView.backgroundColor = [UIColor colorWithRed:0.988f green:0.984f blue:0.973f alpha:1.0];

		isTextField = FALSE;
		[self setClipsToBounds:FALSE];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasTextField:(BOOL)hasTextField isForNumbers:(BOOL)forNumbers {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.font = [UIFont fontWithName:@"GillSans-Bold" size:17];
		self.textLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.8];
		self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.textLabel.textColor = [UIColor blackColor];
		/*self.detailTextLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.font = [UIFont fontWithName:@"GillSans-Bold" size:17];
		self.detailTextLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.8];
		self.detailTextLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.detailTextLabel.textColor = [UIColor colorWithWhite:0.78 alpha:1.0];//[UIColor colorWithRed:.22 green:.33 blue:.53 alpha:1.0];
		self.detailTextLabel.textAlignment = UITextAlignmentLeft;*/
		self.opaque = YES;
		self.backgroundView.opaque = YES;
		self.backgroundView.backgroundColor = [UIColor colorWithRed:0.988f green:0.984f blue:0.973f alpha:1.0];
		if (hasTextField) {
			AdyCellTextField * tf;
			if (forNumbers) {
				tf = [[AdyNumberTextField alloc] init];
			} else {
				tf = [[AdyCellTextField alloc] init];
			}
			tf.autocorrectionType = UITextAutocorrectionTypeNo;
			tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
			tf.textAlignment = UITextAlignmentLeft;
			tf.font = [UIFont fontWithName:@"GillSans-Bold" size:17];
			tf.backgroundColor = [UIColor clearColor];
			tf.textColor = [UIColor colorWithRed:0.62f green:0.60f blue:0.51f alpha:1.0];
            [self setTextField:tf];
			[tf setCell:self];
			[tf release];
			isTextField = TRUE;
            [self addSubview:textField];
		} else {
			isTextField = FALSE;
		}
		[self setClipsToBounds:FALSE];
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
	[textField release];
}

/*
 - (void)setSelected:(BOOL)selected animated:(BOOL)animated {
 
 //[super setSelected:selected animated:animated];
 
 if (selected)
 [self setSelectedImage:[UIImage imageNamed:@"ListingsCellPressed.png"]];//Image that i want on Selection
 else
 [self setSelectedImage:[UIImage imageNamed:@"ListingsCellPressed.png"]];
 //Normal image at background everytime table loads.
 
 // Configure the view for the selected state
 
 }*/

-(void)layoutSubviews{
	//CGRect currentBounds = self.bounds;
    
	[super layoutSubviews];
    
    
    
	//CGRect detailsLabelFrame = self.detailTextLabel.frame;
	/*CGSize sizeText = [self.textLabel.text sizeWithFont: self.textLabel.font
                                      constrainedToSize: CGSizeMake(500, 23)
                                          lineBreakMode: UILineBreakModeTailTruncation];
	int endOfText = self.textLabel.bounds.origin.x + sizeText.width;
	detailsLabelFrame.origin = CGPointMake(((endOfText + 20)>110)?(endOfText + 20):110 , 9);
	detailsLabelFrame.size = CGSizeMake(currentBounds.size.width - detailsLabelFrame.origin.x - 28 , detailsLabelFrame.size.height);
	self.detailTextLabel.frame = detailsLabelFrame;
	self.detailTextLabel.textAlignment = UITextAlignmentLeft;
	CGRect mainLabelFrame = self.textLabel.frame;
    
    
	mainLabelFrame.origin.x += 5; 
	mainLabelFrame.size = sizeText;
    
	self.textLabel.frame = mainLabelFrame;
	detailsLabelFrame.origin.x += 10;
	if ([[self textField] isSecureTextEntry]) {
		detailsLabelFrame.origin.y += 1;
	} else {
		detailsLabelFrame.origin.y += 2;
	}*/

    self.detailTextLabel.frame = [self textField].frame = CGRectMake(130, self.textLabel.frame.origin.y + 2, 160, self.textLabel.frame.size.height + 3);
    
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
	
    [super willTransitionToState:state];
	
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
		
        for (UIView *subview in self.subviews) {
			
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {             
				
                subview.hidden = YES;
                subview.alpha = 0.0;
            }
        }
    }
	for (UIView *subview in self.subviews) {
		//NSLog(@"%@",[subview class]);
		if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]) {             				
			UIView *deleteButtonView = (UIView *)[subview.subviews objectAtIndex:0];
			CGRect f = deleteButtonView.frame;
			deleteButtonView.frame = f;
			
			subview.hidden = YES;
		}
		if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellReorderControl"]) {
			//NSLog(@"%@",subview.subviews);
			UIView *deleteButtonView = (UIView *)[subview.subviews objectAtIndex:0];
			CGRect f = deleteButtonView.frame;
			deleteButtonView.frame = f;
			
			subview.hidden = NO;
			[deleteButtonView setNeedsDisplay];
		}
	}
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
	
    [super willTransitionToState:state];
	
    if (state == UITableViewCellStateShowingDeleteConfirmationMask || state == UITableViewCellStateDefaultMask) {
        for (UIView *subview in self.subviews) {
			
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
				
                UIView *deleteButtonView = (UIView *)[subview.subviews objectAtIndex:0];
                CGRect f = deleteButtonView.frame;
                f.origin.x -= 20;
				f.origin.y += 0;
                deleteButtonView.frame = f;
				
                subview.hidden = NO;
				
                [UIView beginAnimations:@"anim" context:nil];
                subview.alpha = 1.0;
                [UIView commitAnimations];
            }
        }
    }
}


@end
