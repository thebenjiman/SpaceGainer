//
//  UBAppDelegate.h
//  SpaceGainer
//
//  Created by Benjamin DOMERGUE on 15/01/2014.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class UBFolderScannerResults;
@interface UBAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
	
@property (strong) IBOutlet NSView *buttonsView;

@property (strong) IBOutlet NSButton *scanFolderButton;
@property (strong) IBOutlet NSProgressIndicator *progressBar;

@property (strong) IBOutlet NSTableView *searchResultTableView;
@property (strong) IBOutlet NSScrollView *searchResultScrollView;
@property (strong) UBFolderScannerResults *searchResults;

@property (strong) IBOutlet NSTextField *informativeTextField;
@property (strong) IBOutlet NSButton *gainSpaceButton;

@end
