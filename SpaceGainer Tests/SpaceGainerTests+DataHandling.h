//
//  SpaceGainerTests+DataHandling.h
//  SpaceGainer
//
//  Created by Benjamin DOMERGUE on 16/01/2014.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "SpaceGainerTests.h"

#define TEST_CONTENT_DATA_CHUNK_1 @"A chunk of string for testing"
#define TEST_CONTENT_DATA_CHUNK_2 @"A second chunk of string for testing for subdirectories"
#define TEST_CONTENT_DATA_CHUNK_3 @"A chunk of string for testing that will have no duplicates"

@interface SpaceGainerTests (TestDataHandling)

- (void)createTestDirectories;
- (void)createTestData;

- (void)deleteTestDirectory;

@end
