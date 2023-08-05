//
//  TmpDirectoryManager.m
//  Boomerang
//
//  Created by 이정훈 on 2023/08/04.
//

#import <Foundation/Foundation.h>
#import "Boomerang-Bridging-Header.h"

//class 구현부
@implementation DirectoryManager

-(id)init{

    self = [super init];
    if(self){
        
    }
    return self;
}

+(void) deleteTmpDirectory {
    NSArray* temp = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in temp) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
}

@end
