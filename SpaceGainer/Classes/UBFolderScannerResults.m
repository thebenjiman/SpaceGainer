//
//  UBFolderScannerResults.m
//  SpaceGainer
//
//  Created by Benjamin DOMERGUE on 16/01/2014.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "UBFolderScannerResults.h"

@implementation UBFolderScannerResults

- (void)_prepareOrderedArray
{
	NSMutableArray *orderArray = [NSMutableArray new];
	
	[self.items.allKeys enumerateObjectsUsingBlock:^(NSURL *fileURL, NSUInteger idx, BOOL *stop)
	 {
		 if (orderArray.count == 0)
		 {
			 [orderArray addObject:fileURL];
		 }
		 else
		 {
			 NSUInteger fileLength = [[NSData dataWithContentsOfFile:[fileURL path]
															 options:NSDataReadingMappedAlways
															   error:nil] length];
			 BOOL wasInserted = NO;
			 NSUInteger index = 0;
			 for (NSURL *comparedFileURL in orderArray)
			 {
				 NSUInteger comparedFileLength = [[NSData dataWithContentsOfFile:[comparedFileURL path]
																		 options:NSDataReadingMappedAlways
																		   error:nil] length];
				 if (comparedFileLength > fileLength)
				 {
					 ++index;
				 }
				 else
				 {
					 [orderArray insertObject:fileURL atIndex:index];
					 wasInserted = YES;
					 break;
				 }
			 }
			 if (!wasInserted)
			 {
				 [orderArray addObject:fileURL];
			 }
		 }
	 }];
	
	_orderedKeysArray = [NSArray arrayWithArray:orderArray];
}

- (void)_preparePossibleGainsDictionary
{
	NSMutableDictionary *possibleGains = [NSMutableDictionary dictionary];
	[self.items.allKeys enumerateObjectsUsingBlock:^(NSURL *fileURL, NSUInteger idx, BOOL *stop)
	 {
		 NSArray *duplicatesURLs = self.items.allValues[idx];
		 
		 NSData *data = [NSData dataWithContentsOfURL:fileURL];
		 [possibleGains setObject:@(data.length * [duplicatesURLs count]) forKey:fileURL];
		 
		 [self.checkedStates addObject:@NO];
	 }];
	
	_possibleGains = [NSDictionary dictionaryWithDictionary:possibleGains];
}

- (id)initWithSearchResultsDictionary:(NSDictionary *)searchResults
{
	if ((self = [super init]))
	{
		_checkedStates = [NSMutableArray new];
		_items = [searchResults copy];
		
		[self _preparePossibleGainsDictionary];
		[self _prepareOrderedArray];
	}
	return self;
}

@end
