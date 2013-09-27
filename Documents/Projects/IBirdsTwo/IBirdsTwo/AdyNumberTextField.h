//
//  AdyNumberTextField.h
//  Adylitica
//
//  Created by Samuel Westrich on 1/12/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdyCellTextField.h"

typedef enum eNumberTextField {
	eNumberTextField_ForZIP = 0,
	eNumberTextField_ForPrice = 1,
	eNumberTextField_ForSize = 2,
    eNumberTextField_ForOther = 3
}eNumberTextField;

@interface AdyNumberTextField : AdyCellTextField {
	eNumberTextField forWhat;
	bool needsChange; //prevents infinite loops
}

@property(nonatomic,assign) eNumberTextField forWhat;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
