---
layout: default
category: obj
title: "GloopObjects"
---

# GloopObject
A GloopObject is any instance of an Object that subclasses (inherits) from the `GLPObject` class **OR** adheres to (implements) the `<GLPObject>` protocol.

## Storing data
GloopObjects are saved automatically when they are created.
The database stores an accurate representation of GloopObject - both locally and remotely.

###GloopObject Structure
The structure of each GloopObject is determined its class.
#####Objective-C Class:

```Objective-c
@interface Person : NSObject<GLPObject> {
    int shoe_size;
}

@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *age;

@end
```


#####Objective-C GloopObject:

```Objective-c
Person *aPerson = [Person new];
aPerson.show_size = 8;
aPerson.name = @"John";
aPerson.age = @32;
```


#####SQL representation:

`Person`

|objectId|shoe_size|name|age|
|---|---|---|---|
|f9bfca3c-3fdf-4586-9a43-7de6034cf804|8|John|32|

###Supported Datatypes
Each property that belongs to a GloopObjects can be one of the following types:
**bool, int, float, double, NSString, NSDate, NSData, and NSNumber**
Other datatypes are be supported using CustomSerializers, which are explained in the Serializer section.


###Relationships
GloopObjects maintain relationships with other GloopObjects. When a GloopObject has a property that is also a GloopObject, it is called a parent-child relationship. If the parent object is saved, the child object will automatically be saved. A single GloopObject can be both a parent and a child at the same time.

In a parent-child relationship, the child is saved independantly and a reference to the child is stored inside the parent. Although internally the property on the parent is just a reference to the child, it is indistinguishable from the real child.

## Retrieving data

###Predicates
Retrieving data is done with queries in Apples `NSPredicate` format.

```Objective-c
GLPArray *old_people = [[[[People all] where:@"age >= 30"] sortBy:@"name"] ascending:YES];

GLPArray *johns = [old_people where:@"name == 'John'"];

NSLog(@"%d",johns.count); // Will print 1
```
`GLPArray` is a direct subclass of `NSArray`, so is compatible with everything that a normal array can do. GloopObjects that are inside of a `GLPArray` (and the child GloopObjects in parent-child Relationships) are lazily loaded, so they will not exist in memory until they are actually accessed.

If you want to do more complicated queries, or just prefer SQL, standard SQLite syntax is also supported:

```Objective-c
GLPArray *really_old_people = [[People all] SQL:@"WHERE age >= 40 AND name LIKE 'J%''"];
```