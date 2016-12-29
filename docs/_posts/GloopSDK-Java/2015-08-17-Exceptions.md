---
layout: default
category: jav
title: "Exceptions"
---

# Handling Errors

## Gloop Exceptions

Gloop exceptions are divided in two base classes: `GloopException` and `GloopInternalException`. `GloopExceptions` are the exceptions witch are thrown to the developer. This exceptions don't need to be caught but can be caught by the developer. The exceptions are always thrown if something went wrong. The developer has the chance to react on this errors otherwise the app will crash.
`GloopInternalExceptions` are exceptions for the internal use in the SDK. This exceptions need to be caught. 

## IGloopException
`IGloopException` is the interface witch every other custom exception of Gloop SDK implements. 

## GloopException

- GloopSaveException
- GloopLoadException
- GloopDeleteException
- GloopUpdateException
- GloopSyncException

<!--For example catch every Gloop exception:

```java
try {
	new Animal().save();
} catch (GloopException e) {
	// do something
}
```

 or if you want to catch a specific exception:
 
```java
try {
	new Animal().save();
} catch (GloopSaveException e) {
	// do something
}
```-->

For example:

```java
try {
	Animal animal = new Animal();
	animal.save();
	
	animal.setName("Alex");
	animal.update();
	
	animal.delete();
} catch (GloopSaveException e ) {
	// do something on save exception
} catch (GloopUpdateException ue) {
	// do something on update exception
} catch (GloopDeleteException de) {
	// do something on delete exception
}
```
or simply do:

```java
try {
	Animal animal = new Animal();
	animal.save();
	
	animal.setName("Alex");
	animal.update();
	
	animal.delete();
} catch (GloopException e ) {
	// do something on any gloop exception
}
```
or if you don't want to catch the exceptions:

```java
Animal animal = new Animal();
animal.save();

animal.setName("Alex");
animal.update();

animal.delete();
```

