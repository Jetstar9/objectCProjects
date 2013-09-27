//
//  TextInputCell.h
//  iBirds
//
//  Created by Samuel Westrich on 9/19/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdyCellTextField.h"

@interface TextInputCell : UITableViewCell {
	AdyCellTextField * textField;
	bool isTextField;
}
@property(nonatomic,retain) AdyCellTextField * textField;
@property(nonatomic,assign) bool isTextField;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasTextField:(BOOL)hasTextField isForNumbers:(BOOL)forNumbers;
@end
