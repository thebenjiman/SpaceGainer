//
//  UBAppDelegate+TableView.h
//  SpaceGainer
//
//  Created by Benjamin DOMERGUE on 16/01/2014.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "UBAppDelegate.h"

/* Identifier used in the XIB file to define the columns */
#define TABLE_COLUMN_NAME @"NameColumn"
#define TABLE_COLUMN_DESCRIPTION @"DescriptionColumn"
#define TABLE_COLUMN_CHECK @"CheckColumn"
/* EO identifiers */

@interface UBAppDelegate (TableViewComputation)
- (void)userDidChangeCheckStateOfRow;
@end

@interface UBAppDelegate (TableViewInterface)

- (void)showResultTable;
- (void)hideResultTable;

@end

@interface UBAppDelegate (TableView) <NSTableViewDataSource, NSTableViewDelegate>

@end
