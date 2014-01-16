//
//  SpaceGainerTests.m
//  SpaceGainer Tests
//
//  Created by Benjamin DOMERGUE on 16/01/2014.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "SpaceGainerTests.h"
#import "SpaceGainerTests+DataHandling.h"

#import "UBFolderScanner.h"
#import "UBFolderScannerResults.h"

@interface SpaceGainerTests (UBFolderScannerDelegate) <UBFolderScannerDelegate> @end
@implementation SpaceGainerTests (UBFolderScannerDelegate)

- (void)folderScanner:(UBFolderScanner *)folderScanner finishedScanWithResult:(UBFolderScannerResults *)folderScanResult
{
	_searchResults = folderScanResult;
}

@end

@implementation SpaceGainerTests

- (void)setUp
{
    [super setUp];
	
	[self createTestDirectories];
	[self createTestData];
	
	_searchResults = nil;
}

- (void)tearDown
{
	[self deleteTestDirectory];
	
    [super tearDown];
}

- (void)testModelIntegrity
{
	UBFolderScanner *folderScanner = [[UBFolderScanner alloc] initWithFolderURL:_testDirectoryURL];
	folderScanner.delegate = self;
	[folderScanner startFolderScanning];
	
	while (!_searchResults) // Wait for the dispatched job is done
	{
		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.05]];
	}
	
	// Make sure the number of items found is good
	XCTAssertTrue(_searchResults.items.allKeys.count == 2U, @"Two entries should have been listed");
	XCTAssertTrue(_searchResults.possibleGains.allKeys.count == 2U, @"Two entries should have been listed");
	XCTAssertTrue(_searchResults.orderedKeysArray.count == 2U, @"Two entries should have been listed");
	XCTAssertTrue(_searchResults.checkedStates.count == 2U, @"Two entries should have been listed");
	
	// Make sure all the number of clone per items is good
	[_searchResults.items enumerateKeysAndObjectsUsingBlock:^(NSURL *fileURL, id obj, BOOL *stop)
	 {
		 NSArray *duplicateURLs = _searchResults.items[fileURL];
		 
		 NSData *chunk = [NSData dataWithContentsOfURL:fileURL];
		 NSString *chunkContent = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
		 if ([chunkContent isEqualToString:TEST_CONTENT_DATA_CHUNK_1])
		 {
			 XCTAssertTrue(duplicateURLs.count == 1U, @"One entry has been created for this file");
		 }
		 else if ([chunkContent isEqualToString:TEST_CONTENT_DATA_CHUNK_2])
		 {
			 XCTAssertTrue(duplicateURLs.count == 2U, @"Two entries have been created for this file");
		 }
	}];
	
	// Make sure the file order is right (Larger first)
	[_searchResults.orderedKeysArray enumerateObjectsUsingBlock:^(NSURL *fileURL, NSUInteger idx, BOOL *stop)
	{
		NSData *chunk = [NSData dataWithContentsOfURL:fileURL];
		NSString *chunkContent = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
		if (idx == 0)
		{
			XCTAssertTrue([chunkContent isEqualToString:TEST_CONTENT_DATA_CHUNK_2], @"The second chunk is longer, should be first in the list");
		}
		else if (idx == 1)
		{
			XCTAssertTrue([chunkContent isEqualToString:TEST_CONTENT_DATA_CHUNK_1], @"The first chunk is shorter, should be second in the list");
		}
	}];
}

@end
