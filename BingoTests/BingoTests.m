//
//  BingoTests.m
//  BingoTests
//
//  Created by feialoh on 18/11/13.
//  Copyright (c) 2013 feialoh. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BingoTests : XCTestCase

@end

@implementation BingoTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
     int randindex=arc4random()%2;
    
    NSLog(@"Result is:%d",randindex);
    
    XCTAssertTrue((randindex==1||randindex==2), @"%d",randindex);
    
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
