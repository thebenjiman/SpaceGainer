//
//  UBAppDelegate+TableView.m
//  SpaceGainer
//
//  Created by Benjamin DOMERGUE on 16/01/2014.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "UBAppDelegate+TableView.h"
#import "UBFolderScannerResults.h"

@implementation UBAppDelegate (TableViewComputation)

- (void)userDidChangeCheckStateOfRow
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
				   {
					   __block CGFloat possibleGain = .0;
					   __block BOOL atLeastOneCheckBoxWasChecked = NO;
					   [self.searchResults.checkedStates enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop)
						{
							if ([obj boolValue] == YES)
							{
								NSURL *key = self.searchResults.orderedKeysArray[idx];
								CGFloat possibleGainForRow = [(NSNumber *)self.searchResults.possibleGains[key] unsignedLongLongValue];
								possibleGain += possibleGainForRow;
								
								atLeastOneCheckBoxWasChecked = YES;
							}
						}];
					   
					   dispatch_async(dispatch_get_main_queue(), ^
									  {
										  self.gainSpaceButton.enabled = atLeastOneCheckBoxWasChecked;
										  self.informativeTextField.hidden = !atLeastOneCheckBoxWasChecked;
										  
										  BOOL largerThanAMega = possibleGain > 1024 * 1024;
										  NSString *descriptionText = [NSString stringWithFormat:@"You will free %.2f %@", largerThanAMega ? possibleGain/1024/1024 : possibleGain/1024, largerThanAMega ? @"MB" : @"KB"];
										  [self.informativeTextField setStringValue:descriptionText];
									  });
				   });
}

@end

@implementation UBAppDelegate (TableView)

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return self.searchResults.orderedKeysArray.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_NAME])
	{
		NSURL *firstCloneURL = self.searchResults.orderedKeysArray[row];
		return [[firstCloneURL path] lastPathComponent];
	}
	else if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_DESCRIPTION])
	{
		NSURL *key = self.searchResults.orderedKeysArray[row];
		NSArray *copiesURLs = self.searchResults.items[key];
		
		CGFloat possibleGain = [(NSNumber *)self.searchResults.possibleGains[key] unsignedLongLongValue];
		BOOL largerThanAMega = possibleGain > 1024 * 1024;
		
		NSString *descriptionLine = [NSString stringWithFormat:
									 
									 @"%lu copie%@ for a total of %.2f %@",
									 
									 [copiesURLs count],
									 [copiesURLs count] > 1 ? @"s" : @"",
									 largerThanAMega ? possibleGain/1024/1024 : possibleGain/1024,
									 largerThanAMega ? @"MB" : @"KB"];
		
		return descriptionLine;
	}
	else if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_CHECK])
	{
		return self.searchResults.checkedStates[row];
	}
	return nil;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_CHECK])
	{
		[self.searchResults.checkedStates replaceObjectAtIndex:row withObject:object];
		[self userDidChangeCheckStateOfRow];
	}
}

@end

@implementation UBAppDelegate (TableViewInterface)

- (void)hideResultTable
{
	[self.window setContentSize:self.buttonsView.frame.size];
}

- (void)showResultTable
{
	NSSize buttonViewSize = self.buttonsView.frame.size;
	NSSize scrollViewSize = self.searchResultScrollView.frame.size;
	
	NSSize fullSize = NSMakeSize(buttonViewSize.width, buttonViewSize.height + scrollViewSize.height);
	[self.window setContentSize:fullSize];
}

@end
