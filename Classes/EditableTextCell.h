//
//  EditableTextCell.h
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditableTextCell : UITableViewCell {
@private
	UITextField* textField;
}

@property (nonatomic, retain) UITextField *textField;

@end
