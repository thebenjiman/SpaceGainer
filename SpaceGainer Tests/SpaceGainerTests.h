//
//  SpaceGainerTests.h
//  SpaceGainer
//
//  Created by Benjamin DOMERGUE on 16/01/2014.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import <XCTest/XCTest.h>

/* 
 * Those test will garanty that our model objects stay consistent.
 */

@class UBFolderScannerResults;
@interface SpaceGainerTests : XCTestCase
{
	NSURL *_testDirectoryURL;
	UBFolderScannerResults *_searchResults;
}

@end
