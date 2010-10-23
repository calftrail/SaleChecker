//
//  EditableTextCell.m
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditableTextCell.h"


@implementation EditableTextCell

@synthesize textField;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)reuseIdentifier {
	self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
        // set the frame to CGRectZero as it will be reset in layoutSubviews
		UITextField* theTextField = [[UITextField alloc] initWithFrame:CGRectZero];
		theTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        theTextField.font = [UIFont systemFontOfSize:32.0f];
        theTextField.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:theTextField];
		self.textField = theTextField;
		[theTextField release];
    }
    return self;
}

- (void)dealloc {
    self.textField = nil;
    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
    self.textField.frame = CGRectInset(self.contentView.bounds, 10, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textField.textColor = [UIColor whiteColor];
    } else {
        self.textField.textColor = [UIColor darkGrayColor];
    }
}

@end
