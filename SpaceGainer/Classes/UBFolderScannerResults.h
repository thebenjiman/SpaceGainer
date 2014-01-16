//
//  UBFolderScannerResults.h
//  SpaceGainer
//
//  Created by Benjamin DOMERGUE on 16/01/2014.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * This object is our main model class.
 *
 * It holds collections of duplicates and also to store the user's choices
 * when they are made.
 *
 * You create an instance by calling the method -initWithSearchResultsDictionary:
 * The argument of the init method is a dictionary containing an entry for each file 
 * that were found duplicated; the value of the entry is an array containing all the clones paths;
 * the key of the entry in the dictionary is the path of the first clone found.
 *
 */

@interface UBFolderScannerResults : NSObject

- (id)initWithSearchResultsDictionary:(NSDictionary *)searchResults;

@property (readonly) NSDictionary *items, *possibleGains;

@property (readonly) NSArray *orderedKeysArray;
@property (readonly) NSMutableArray *checkedStates;

@end
