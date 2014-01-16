//
//  UBFolderScanner.h
//  SpaceGainer
//
//  Created by Benjamin DOMERGUE on 15/01/2014.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * This class is the main utility class of the application.
 * It is responsible for scanning a folder for duplicate files and also notify of the progress of this task.
 *
 * Two ways can be use to create an instance, you can allocate, initiate the object then set the URL of the folder
 * to scan or use the convenience method - (id)initWithFolderURL:
 *
 * You have to make sure you specify a delegate to your UBFolderScanner object. Once this property is 
 * set you can call the method - (void)startFolderScanning. 
 *
 * The returned dictionary 
 *
 */

@class UBFolderScanner;
@class UBFolderScannerResults;
@protocol UBFolderScannerDelegate

@required
- (void)folderScanner:(UBFolderScanner *)folderScanner finishedScanWithResult:(UBFolderScannerResults *)folderScanResult;

@optional
- (void)folderScanner:(UBFolderScanner *)folderScanner didProgress:(CGFloat)currentProgress;

@end

@interface UBFolderScanner : NSObject

/* Properties */
@property (weak) NSObject <UBFolderScannerDelegate> *delegate;
@property (strong) NSURL *folderURL;

/* Methods */
- (id)initWithFolderURL:(NSURL *)folderURL;
- (void)startFolderScanning;

@end
