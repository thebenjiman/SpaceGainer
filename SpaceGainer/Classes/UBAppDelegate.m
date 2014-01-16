//
//  UBAppDelegate.m
//  SpaceGainer
//
//  Created by Benjamin DOMERGUE on 15/01/2014.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "UBAppDelegate.h"
#import "UBAppDelegate+TableView.h"

#import "UBFolderScanner.h"
#import "UBFolderScannerResults.h"

@interface UBAppDelegate (/* Private properties */)
@property (strong) UBFolderScanner *currentScanner;
@end

@interface UBAppDelegate (FolderScannerDelegate) <UBFolderScannerDelegate>
@end

@interface UBAppDelegate (Interface)

- (void)restoreProgressBarInitialeState;

- (void)showSimpleAlertWithText:(NSString *)text;

- (NSOpenPanel *)openPanel;
- (void)configureWindowForApplicationStart;

@end

@interface UBAppDelegate (Actions)
- (IBAction)selectFolder:(id)sender;
@end

@implementation UBAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self configureWindowForApplicationStart];
}

@end

@implementation UBAppDelegate (FolderScannerDelegate)

- (void)folderScanner:(UBFolderScanner *)folderScanner didProgress:(CGFloat)currentProgress
{
	self.progressBar.indeterminate = NO;
	self.progressBar.doubleValue = currentProgress;
}

- (void)folderScanner:(UBFolderScanner *)folderScanner finishedScanWithResult:(UBFolderScannerResults *)folderScanResult
{
	if (folderScanResult.items.allKeys.count == 0)
	{
		[self showSimpleAlertWithText:@"No duplicate files were found ;)"];
		self.scanFolderButton.enabled = NO;
	}
	else
	{
		self.searchResults = folderScanResult;
		
		self.informativeTextField.hidden = YES;
		self.gainSpaceButton.enabled = NO;
		
		[self.searchResultTableView reloadData];
		
		[self showResultTable];
	}
	[self restoreProgressBarInitialeState];
}

@end

@implementation UBAppDelegate (Actions)

- (IBAction)selectFolder:(id)sender
{
	NSOpenPanel *openPanel = [self openPanel];
	[openPanel beginSheetModalForWindow:self.window
					  completionHandler:^(NSInteger result)
	 {
		 if (result == NSFileHandlingPanelOKButton)
		 {
			 NSURL *URL = openPanel.URLs[0];
			 if (URL)
			 {
				 self.currentScanner = [[UBFolderScanner alloc] initWithFolderURL:URL];
				 self.currentScanner.delegate = self;
			 }
			 else self.currentScanner = nil;
		 }
		 else
		 {
			 self.currentScanner = nil;
		 }
		 
		 self.scanFolderButton.enabled = self.currentScanner ? YES: NO;
	 }];
}

- (IBAction)startCurrentFolderScan:(id)sender
{
	[self.progressBar setHidden:NO];
	[self.progressBar startAnimation:self];
	
	[self.currentScanner startFolderScanning];
}

- (IBAction)deleteDuplicates:(id)sender
{
	[self.searchResults.checkedStates enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop)
	 {
		 if ([obj boolValue] == YES)
		 {
			 NSURL *key = self.searchResults.orderedKeysArray[idx];
			 
			 NSArray *duplicatesURLs = self.searchResults.items[key];
			 [duplicatesURLs enumerateObjectsUsingBlock:^(NSURL *duplicateURL, NSUInteger idx, BOOL *stop)
			  {
				  NSError *error = nil;
				  NSFileManager *fileManager = [NSFileManager defaultManager];
				  if(![fileManager removeItemAtURL:duplicateURL error:&error])
				  {
					  if (error)
					  {
						  NSLog(@"*** %s An error occured while trying to delete file at URL %@: %@", __PRETTY_FUNCTION__, duplicateURL, error);
					  }
				  }
			  }];
		 }
	 }];
	
	self.currentScanner = nil;
	self.gainSpaceButton.enabled = self.scanFolderButton.enabled = NO;
	self.informativeTextField.hidden = YES;
	[self hideResultTable];
	
	[self showSimpleAlertWithText:@"Cleanup is complete"];
}

@end

@implementation UBAppDelegate (Interface)

- (void)restoreProgressBarInitialeState
{
	self.progressBar.indeterminate = YES;
	self.progressBar.hidden = YES;
	
	self.progressBar.doubleValue = .0;
}

- (void)showSimpleAlertWithText:(NSString *)text
{
	NSAlert *noCloneFoundAlert = [NSAlert alertWithMessageText:text defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
	[noCloneFoundAlert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:NULL contextInfo:0];
}

- (NSOpenPanel *)openPanel
{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	
	openPanel.allowsMultipleSelection = NO;
	openPanel.canChooseFiles = NO;
	
	openPanel.resolvesAliases = YES;
	openPanel.canChooseDirectories = YES;
	
	return openPanel;
}

- (void)configureWindowForApplicationStart
{
	[self hideResultTable];
}

@end
