//
//  DCTCustomViewCell.m
//  QuitSmokingApplication2
//
//  Created by Derek Smith on 12-10-27.
//  Copyright (c) 2012 Derek Smith. All rights reserved.
//

#import "DCTCustomViewCell.h"

@implementation DCTCustomViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
