//
//  AdyNumberTextField.m
//  Adylitica
//
//  Created by Samuel Westrich on 1/12/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import "AdyNumberTextField.h"

#define NUMBERS	@"0123456789"
#define NUMBERSPERIOD	@"0123456789."
#define NUMBERSDASH	@"0123456789-"
@implementation AdyNumberTextField

@synthesize forWhat;

-(id)initWithFrame:(CGRect)frame {
	[super initWithFrame:frame];
	needsChange = TRUE;
	[self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	return self;
}

-(void)textFieldDidChange:(UITextField *)textField {
	switch (forWhat) {
		case eNumberTextField_ForZIP:
		{
		}
			break;
		case eNumberTextField_ForPrice:
		{
			
			NSCharacterSet *cs;
			NSString *filtered;
			cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSPERIOD] invertedSet];
			filtered = [[textField.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
			double num = [filtered doubleValue];
			int dec = (num - floor(num)) * 100;
			long long inum = [filtered intValue];
			NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:15];
			while (inum > 999) {
				[array addObject:[NSNumber numberWithDouble:inum%1000]];
				inum = inum/1000;
			}
			[array addObject:[NSNumber numberWithDouble:inum%1000]];
			NSMutableString * newString = [[NSMutableString alloc] initWithCapacity:1000];
			int i;

			for (i=([array count] - 1);i>0;i--) {
				if ( [array count] - 1 != i) {
					if ([[array objectAtIndex:i] intValue]<100) [newString appendString:@"0"];
					if ([[array objectAtIndex:i] intValue]<10) [newString appendString:@"0"];
				}
				[newString appendString:[[array objectAtIndex:i] stringValue]];
				[newString appendString:@","];
			}
			if ([array count]!=1) {
			if ([[array objectAtIndex:i] intValue]<100) [newString appendString:@"0"];
			if ([[array objectAtIndex:i] intValue]<10) [newString appendString:@"0"];
			}
			[newString appendString:[[array objectAtIndex:i] stringValue]];
			[self removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
			// Check for period
			if ([self.text rangeOfString:@"."].location == NSNotFound)
			{
				[textField setText:[NSString stringWithFormat:@"$%@",newString]];
			} else {
				[textField setText:[NSString stringWithFormat:@"$%@.%d",newString,dec]];
			}
			[array release];
			[newString release];
		}
			break;
		case eNumberTextField_ForSize:
		{

		}
			break;
        case eNumberTextField_ForOther:
		{
            
		}
			break;
	}			
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	switch (forWhat) {
		case eNumberTextField_ForZIP:
		{
			if ([string length] == 0) return TRUE;
			if ([textField.text length] > 9) return FALSE; //5 + 4
			NSCharacterSet *cs;
			NSString *filtered;
			// Check for period
			if ([self.text rangeOfString:@"-"].location == NSNotFound)
			{
				if ([string rangeOfString:@"-"].location != NSNotFound) {
					int loc = [string rangeOfString:@"-"].location + 1;
					if (([textField.text length] + loc) != 6) {
						return FALSE;
					}
					cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSDASH] invertedSet];
					filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
					return [string isEqualToString:filtered];
				} else {
					if ([textField.text length] > 4) return FALSE;
					cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSDASH] invertedSet];
					filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
					return [string isEqualToString:filtered];
				}
			}
			
			// No period
			
			cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
			filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
			return [string isEqualToString:filtered];
		}
		break;
		case eNumberTextField_ForPrice:
		{
			[self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
			NSCharacterSet *cs;
			NSString *filtered;
			
			// Check for period
			if ([self.text rangeOfString:@"."].location == NSNotFound)
			{
				cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSPERIOD] invertedSet];
				filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
				return [string isEqualToString:filtered];
			}
			
			// Period is in use
			cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
			filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
			return [string isEqualToString:filtered];
		}
			break;
		case eNumberTextField_ForSize:
		{
			NSCharacterSet *cs;
			NSString *filtered;
			
			// Check for period
			if ([self.text rangeOfString:@"."].location == NSNotFound)
			{
				cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSPERIOD] invertedSet];
				filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
				return [string isEqualToString:filtered];
			}
			
			// Period is in use
			cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
			filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
			return [string isEqualToString:filtered];
		}
			break;
        case eNumberTextField_ForOther:
		{
            NSCharacterSet *cs;
			NSString *filtered;
			
			// Check for period
			if ([self.text rangeOfString:@"."].location == NSNotFound)
			{
				cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSPERIOD] invertedSet];
				filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
				return [string isEqualToString:filtered];
			}
			
			// Period is in use
			cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
			filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
			return [string isEqualToString:filtered];
		}
			break;
	}
	return FALSE;
}

@end
