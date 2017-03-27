---
layout: default
category: obj
title: "Serializing Objects"
---

# Serialization
####Note: This section only refers to the serialization of the properties that belong to GloopObjects.

When GloopObjects are saved, an accurate representation of them is kept in the database - both locally and remotely.
The database in Gloop can only understand data in its `Primitive Datatype` form, this must be one of;
bool, int, long, double, string, NSString, NSNumber, and  SerializableObject.

So serializers are used to turn any properties of a GloopObject (that are not already in `Primitive Datatypes`) into `Primitive Datatypes`. During serialization, a serializer gets given an object, and should output a value that is in the form one of the `Primitive Datatypes`. 

Gloop includes a number of common serializers, so the majority of applications will never need  to create `Custom Serializers`, but it is still useful to have an understanding of whats going on internally.

#####Included Serializers

|name|input|output|
|---|---|---|
| NSUUIDSerializer | NSUUID | string |
| NSDateSerializer | NSDate | string |
| NSArraySerializer | NSArray | string |
| NSDictionarySerializer | NSDictionary | string |


###How do they work?
This CalendarAppointment is a GloopObject that has a `time` property with the non-primitive datatype `NSDate`.

```objective-c
@interface CalenderAppointment : GLPObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSDate *time;
@end
```
Luckily the included **NSDateSerializer** can serialize the `NSDate` class.

```objective-c
CalenderAppointment *anAppointment = [CalenderAppointment new];
anAppointment.name = @"Dentist"; // NSString is primitive
anAppointment.time = @[NSDate dateWithTimeIntervalSinceNow:3600]; // NSDate is NOT primitive and will need to be serialized
```
When a `CalenderAppointment` is saved, the **NSDateSerializer** gets given the `NSDate` object, and outputs a string representation that can be stored in the database.

`NSDate` → **NSDateSerializer** → `"13/04/2016 21:35"`

Now the internal `CalenderAppointment` table looks like this:

|objectId|name|time|
|---|---|---|
|f9bfca3c-3fdf-4586-9a43-7de6034cf804| Dentist | 13/04/2016 21:35 |

##Comparators
Comparison operators are used to compare things **`== < > >= <= != `**
Internally, Gloop uses these operators (with the serializer outputs) to create your filters and predicates.
This means if your serializer outputs cannot be compared properly, the filters and predicates will not work correctly.

Serializer outputs should be as logically comparable as possible.

###Example
Fraction is an object that is a property of a GloopObject (and therefore will need to be serialized).

```objective-c
@interface Fraction : NSObject // Fraction is just a property of a GloopObject, not a GloopObject itself
@property (nonatomic) int numerator;
@property (nonatomic) int denomenator;
@end
```
```objective-c
Fraction *aFraction = [Fraction new];  // This Fraction 1/2 represents 0.5
aFraction.numerator = @"1";
aFraction.denominator = @"2";

```
An poorly designed FractionSerializer might output a string containing `"1/2"`. As it has output a string, it will use string (not numeric) comparison, and will compare illogically.

|Comparison|Expected outcome|Logic used|Actual outcome|
|:---:|:---:|:---:|:---:|
|1/2 > 2/5| True | Numeric | True |
|"1/2" > "2/5"| True | String |False |

Instead, a better FractionSerializer might just output the number `0.5`, which would numerically compare with `0.4` correctly.

####Custom Comparators

The Fraction example above doesnt actually make much sense, since the whole point of a dedicated Fraction object would be to keep the numerator and denominator seperate. To keep the `"1/2"` output (while having valid comparison logic) we can use `Custom Comparators`.

`Custom Comparators` enable us to run small bits of code that will modify a value before it is compared, the `Custom Comparator` below will turn the string `"1/2"` into its numeric representation `0.5`.
`substr(value, 1, instr(value, '/'))   /   substr(value, instr(value, '/') + 1)`

The functions available are indentical to those available in SQLite.

##Deserialization
We've seen how a serializer is used to **serialize** properties as they are saved, but a serializer is also used to **deserialize** properties as they are loaded from the database. During deserialization, the output becomes the input and the input becomes the output.

`"{"red":"#FF0000","green":"#00FF00"}"` → **NSDictionarySerializer** → `NSDictionary`

Deserialization is the exact reverse of serialization.


##Metadata
Sometimes when serializing an object, it is neccasary to keep small pieces of information about how the object was serialized, so we can remember how to exactly reverse this during deserialization.

This information could be stored somewhere within the serialized output itself, but this is not a good option because this would cause problems with the comparators. 


#Custom Serializers
Custom serializers provide a way to make any object serializable. There are two ways to create custom serializers, `Dedicated Serializers` and `Self Serializers`.

####Dedicated Serializers
`Dedicated Serializers` are standalone classes that are designed to serialize another object. All of the included serializers are `Dedicated Serializers`.

Dedicated serializers must be a subclass of one of the base serializer classes:

* GLPBaseSerializer
* GLPSerializeToBool
* GLPSerializeToInt
* GLPSerializeToLong
* GLPSerializeToDouble
* GLPSerializeToString
* GLPSerializeToNSString
* GLPSerializeToSerializableObject

and should override both the **serialize** and **deserialize** methods that the base serializer provides.

#####Dedicated Serializer Example
The following example is designed to serialize the `UIColor` class that comes with `UIKit`.
######UIColorSerializer.h
```objective-c
#import <GloopSDK/GloopSDK.h>
#import <UIKit/UIColor.h>

@interface UIColorSerializer : GLPSerializeToSerializableObject (UIColor)
- (id)serialize:(UIColor *)object metaData:(NSMutableDictionary *)metaData;
- (UIColor *)deserialize:(id)serializableValue metaData:(NSDictionary *)metaData;
@end
```
######UIColorSerializer.m
```objective-c
#import "UIColorSerializer.h"

@implementation UIColorSerializer

-(id)serialize:(UIColor *)color metaData:(NSMutableDictionary *)metaData {
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    NSDictionary *colorData = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithFloat:r], @"Red",
                               [NSNumber numberWithFloat:g], @"Green",
                               [NSNumber numberWithFloat:b], @"Blue",
                               [NSNumber numberWithFloat:a], @"Alpha", nil];
    return colorData;
}

-(UIColor *)deserialize:(id)serializableValue metaData:(NSDictionary *)metaData {
    if(serializableValue != nil && ![serializableValue isKindOfClass:[NSDictionary class]]) {
        NSLog(@"UIColorSerializer was expecting a NSDictionary");
        return nil;
    }
    
    NSDictionary *dict = serializableValue;
    CGFloat r, g, b, a;
    r = [(NSNumber*)[dict objectForKey:@"Red"] floatValue];
    g = [(NSNumber*)[dict objectForKey:@"Green"] floatValue];
    b = [(NSNumber*)[dict objectForKey:@"Blue"] floatValue];
    a = [(NSNumber*)[dict objectForKey:@"Alpha"] floatValue];
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
```

####Self Serializers
A `Self Serializers` is just a shorthand way of creating a dedicated serializer, instead of creating a seperate class, a `Self Serializer` is an object that knows how to serialize itself. To become a `Self Serializer`, an object just has to implement the corresponding `GLPSerializeToXXX` protocol and its methods, for example

###Specifying which Serializer to use
Every serializer specifies which class it targets in its header. Gloop will detect this, and automatically use this serializer.

```objective-c
            Arbitary Name             Output          Input
                  ↓                      ↓              ↓
@interface FracionSerializer : GLPSerializeToDouble (Fraction) 
```

But a specific serializer can also be used for a property;

```objective-c
@property (nonatomic, serializer(DifferntFracionSerializer)) Fraction *aFraction; 
```

