//
//  SpaceGainerTests+DataHandling.m
//  SpaceGainer
//
//  Created by Benjamin DOMERGUE on 16/01/2014.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "SpaceGainerTests+DataHandling.h"

#define TEST_DIRECTORY_NAME @"SpaceGainerTest"

#define TEST_DIRECTORY_SUB_PATH_COMPONENTS_1 @"SubDirectory"
#define TEST_DIRECTORY_SUB_PATH_COMPONENTS_2 @"SubDirectory2/Beneath"

@implementation SpaceGainerTests (TestDataHandling)

- (void)createTestDirectories
{
	NSString *directoryPath = [NSTemporaryDirectory() stringByAppendingPathComponent:TEST_DIRECTORY_NAME];
	_testDirectoryURL = [NSURL fileURLWithPath:directoryPath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager createDirectoryAtURL:_testDirectoryURL withIntermediateDirectories:YES attributes:nil error:nil];
	
	NSString *firstSubDirectoryPath = [directoryPath stringByAppendingPathComponent:TEST_DIRECTORY_SUB_PATH_COMPONENTS_1];
	NSString *secondSubDirectoryPath = [directoryPath stringByAppendingPathComponent:TEST_DIRECTORY_SUB_PATH_COMPONENTS_2];
	[fileManager createDirectoryAtURL:[NSURL fileURLWithPath:firstSubDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
	[fileManager createDirectoryAtURL:[NSURL fileURLWithPath:secondSubDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)createTestData
{
	NSData *firstChunk = [TEST_CONTENT_DATA_CHUNK_1 dataUsingEncoding:NSUTF8StringEncoding];
	NSData *secondChunk = [TEST_CONTENT_DATA_CHUNK_2 dataUsingEncoding:NSUTF8StringEncoding];
	NSData *thirdChunk = [TEST_CONTENT_DATA_CHUNK_3 dataUsingEncoding:NSUTF8StringEncoding];
	
	NSString *firstFilePath = [[_testDirectoryURL path] stringByAppendingPathComponent:@"File 1.txt"];
	NSString *secondFilePath = [[_testDirectoryURL path] stringByAppendingPathComponent:@"File 2.txt"];
	[firstChunk writeToURL:[NSURL fileURLWithPath:firstFilePath] atomically:YES];
	[firstChunk writeToURL:[NSURL fileURLWithPath:secondFilePath] atomically:YES];
	
	NSString *thirdFilePath = [[[_testDirectoryURL path] stringByAppendingPathComponent:TEST_DIRECTORY_SUB_PATH_COMPONENTS_1]
							   stringByAppendingPathComponent:@"File 3.txt"];
	NSString *fourthFilePath = [[[_testDirectoryURL path] stringByAppendingPathComponent:TEST_DIRECTORY_SUB_PATH_COMPONENTS_2]
								stringByAppendingPathComponent:@"File 4.txt"];
	NSString *fifthFilePath = [[[_testDirectoryURL path] stringByAppendingPathComponent:TEST_DIRECTORY_SUB_PATH_COMPONENTS_2]
								stringByAppendingPathComponent:@"File 5.txt"];
	[secondChunk writeToURL:[NSURL fileURLWithPath:thirdFilePath] atomically:YES];
	[secondChunk writeToURL:[NSURL fileURLWithPath:fourthFilePath] atomically:YES];
	[secondChunk writeToURL:[NSURL fileURLWithPath:fifthFilePath] atomically:YES];
	
	NSString *sixthFilePath = [[_testDirectoryURL path] stringByAppendingPathComponent:@"File 6.txt"];
	[thirdChunk writeToURL:[NSURL fileURLWithPath:sixthFilePath] atomically:YES];
}

- (void)deleteTestDirectory
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtURL:_testDirectoryURL error:nil];
}

@end
