//
//  Task.h
//  ToDo
//
//  Created by Islam NourEldin on 28/01/2022.
//

#import "Task.h"

@implementation Task  




- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_taskName  forKey:@"Name"];
    [coder encodeObject:_descrpt  forKey:@"Description"];
    [coder encodeObject:_datee  forKey:@"Date"];
    [coder encodeObject:_prior  forKey:@"Priority"];
    [coder encodeInt:_idd  forKey:@"id"];


}


- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if (self=[super init]) {
        _taskName=[coder decodeObjectOfClass:[NSString class] forKey:@"Name"];
        _descrpt=[coder decodeObjectOfClass:[NSString class] forKey:@"Description"];
        _datee=[coder decodeObjectOfClass:[NSDate class] forKey:@"Date"];
        _prior=[coder decodeObjectOfClass:[NSString class] forKey:@"Priority"];
        _idd=[coder decodeIntForKey:@"id"];

    }
    return self;
}
+(BOOL)supportsSecureCoding{
    return true;
}


@end
