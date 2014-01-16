//
//  UBFolderScanner.m
//  SpaceGainer
//
//  Created by Benjamin DOMERGUE on 15/01/2014.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "UBFolderScanner.h"

#import "UBFolderScannerResults.h"

#import <CommonCrypto/CommonDigest.h>
#define HASH_VALUE_STORAGE_SIZE 48

@interface UBFolderScanner (/* Private members, methods and properties */)
{
	NSFileManager *_fileManager;
	
	NSArray *_fileToInspectURLs;
	
	NSMutableDictionary *_comparisonDictionary;
	NSDictionary *_resultDictionary;
}
@end

@interface UBFolderScanner (Utility)
+ (NSUInteger)hashValueWithData:(NSData *)data;
- (void)gatherDuplicatesWithCompletionBlock:(void (^)(void))completion;
@end

@interface UBFolderScanner (Private)
- (NSArray *)_listAllFilesRecursivelyInDirectoryAtURL:(NSURL *)directoryURL;
@end

@implementation UBFolderScanner

- (id)initWithFolderURL:(NSURL *)folderURL
{
	if ((self = [super init]))
	{
		_folderURL = folderURL;
		_fileManager = [NSFileManager new];
		
		_fileToInspectURLs = [NSArray new];
	}
	return self;
}

- (void)startFolderScanning
{
	_resultDictionary = [NSDictionary new];
	_comparisonDictionary = [NSMutableDictionary new];
	_fileToInspectURLs = [self _listAllFilesRecursivelyInDirectoryAtURL:self.folderURL];
	
	if ([_fileToInspectURLs count] != 0)
	{
		if ([self.delegate respondsToSelector:@selector(folderScanner:didProgress:)])
		{
			[self.delegate folderScanner:self didProgress:.0];
		}
		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.05]]; // To let the display refresh
		
		[self gatherDuplicatesWithCompletionBlock:^
		 {
			 UBFolderScannerResults *searchResults = [[UBFolderScannerResults alloc] initWithSearchResultsDictionary:_resultDictionary];
			 [self.delegate folderScanner:self finishedScanWithResult:searchResults];
		}];
	}
	else
	{
		UBFolderScannerResults *searchResults = [[UBFolderScannerResults alloc] initWithSearchResultsDictionary:[NSDictionary new]];
		[self.delegate folderScanner:self finishedScanWithResult:searchResults];
	}
}

@end

@implementation UBFolderScanner (Utility)

+ (NSUInteger)hashValueWithData:(NSData *)data
{
	unsigned char value[HASH_VALUE_STORAGE_SIZE];
	CC_MD5([data bytes], (unsigned int)[data length], value);
	return *((NSUInteger *)value);
}

- (NSNumber *)_hashNumberForFileAtURL:(NSURL *)fileURL
{
	NSError *error = nil;
	NSData *data = [NSData dataWithContentsOfFile:[fileURL path]
										  options:NSDataReadingMappedAlways // essential to avoid having the whole data in our program memory
											error:&error];
	if (!error)
	{
		NSUInteger hashValueForFile = [UBFolderScanner hashValueWithData:data];
		return [NSNumber numberWithUnsignedInteger:hashValueForFile];
	}
	else
	{
		NSLog(@"*** %s An error occured while generating NSData object of file at URL %@: %@", __PRETTY_FUNCTION__, fileURL, error);
		return nil;
	}
}

- (void)gatherDuplicatesWithCompletionBlock:(void (^)(void))completion
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
				   {
					   
					   NSMutableDictionary *duplicatesDictionary = [NSMutableDictionary new];
					   
					   NSUInteger index = 0;
					   for (NSURL *fileURL in _fileToInspectURLs)
					   {
						   NSNumber *hashNumber = [self _hashNumberForFileAtURL:fileURL];
						   if (hashNumber)
						   {
							   if ([_comparisonDictionary objectForKey:hashNumber])
							   {
								   NSURL *firstCloneURL = [_comparisonDictionary objectForKey:hashNumber];
								   NSMutableArray *duplicates = [duplicatesDictionary objectForKey:firstCloneURL];
								   if (!duplicates)
								   {
									   duplicates = [NSMutableArray new];
								   }
								   [duplicates addObject:fileURL];
								   [duplicatesDictionary setObject:duplicates forKey:firstCloneURL];
							   }
							   else
							   {
								   [_comparisonDictionary setObject:fileURL forKey:hashNumber];
							   }
						   }
						   
						   ++index;
						   CGFloat currentProgress = (CGFloat)index / (CGFloat)[_fileToInspectURLs count];
						   if ([self.delegate respondsToSelector:@selector(folderScanner:didProgress:)])
						   {
							   [self.delegate folderScanner:self didProgress:currentProgress];
						   }
					   }
					   
					   _resultDictionary = [NSDictionary dictionaryWithDictionary:duplicatesDictionary];
					   
					   dispatch_async(dispatch_get_main_queue(), ^
									  {
										  if (completion)
										  {
											  completion();
										  }
									  });
				   });
}

@end

@implementation UBFolderScanner (Private)

- (NSArray *)_listAllFilesRecursivelyInDirectoryAtURL:(NSURL *)directoryURL
{
	NSMutableArray *fileURLs = [NSMutableArray new];
	
	NSError *error = nil;
	NSArray *contentURLs = [_fileManager contentsOfDirectoryAtURL:directoryURL
										   includingPropertiesForKeys:nil options:(NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsPackageDescendants) error:&error];
	
	if (!error)
	{
		for (NSURL *URL in contentURLs)
		{
			BOOL isDirectory = NO;
			if([_fileManager fileExistsAtPath:[URL path] isDirectory:&isDirectory])
			{
				if (isDirectory)
				{
					NSArray *subDirectoryFiles = [self _listAllFilesRecursivelyInDirectoryAtURL:URL];
					[fileURLs addObjectsFromArray:subDirectoryFiles];
				}
				else
				{
					[fileURLs addObject:URL];
				}
			}
		}
		return [NSArray arrayWithArray:fileURLs];
	}
	else
	{
		NSLog(@"*** %s An error occured while listing directory at URL %@: %@", __PRETTY_FUNCTION__, directoryURL, error);
		return @[];
	}
}

@end
