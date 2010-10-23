//
//  EditProductController.h
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product, EditableTextCell;

@interface EditProductController : UITableViewController {
@private
	Product* product;
	EditableTextCell* nameCell;
	EditableTextCell* quantityCell;
}

@property (nonatomic, retain) Product* product;

@end
