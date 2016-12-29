---
layout: default
category: jav
title: "Transactions"
---

# Transactions

Read operations are implicit which means that objects can be accessed and queried at any time. All write operations (adding, modifying, and removing objects) should be wrapped in transactions. A transaction can either be committed or cancelled. During the commitment, all changes will be written to disk, and the commitment will only succeed if all changes can be persisted. By cancelling a transaction, all changes will be discarded. Using transactions, your data will always be in a consistent state.

## Code examples:
### beginTransaction, commitTransaction and cancelTransaction

With the `Gloop.beginTransaction()` method, a transaction can be started. Important to know is that this method will create a transaction for the "default" store. If you want to make a transaction for another store, you have to pass the name of the store to a parameter to the beginTransaction method.

```java
Gloop.beginTransaction();		// default store is used

or

Gloop.beginTransaction("storeName");	// "exampleStore" is used
```
To conclude the transaction either `Gloop.commitTransaction()` or `Gloop.cancelTransaction()` can be called.
`commitTransaction` will write every changes done between `beginTransaction` and `commitTransaction`, from this point on the changes are permanently saved in the db. `cancelTransaction` will rollback the database at the start point of the transaction instead. All changes done in this section will be undone in the database.

```java
Gloop.commitTransaction();

or

Gloop.cancelTransaction();
```

It is recommended to use transactions like in the example below:

```java
Gloop.beginTransaction();
try {
	Person person = new Person();
	person.save();

	Gloop.commitTransaction();
} catch (Exception e) {
	Gloop.cancelTransaction();
}
```
Even a better solution to work with transactions is to use transaction blocks.

### Transaction blocks

Instead of manually keeping track of `Gloop.beginTransaction()`, `Gloop.commitTransaction()`, and `Gloop.cancelTransaction()` you can use the `GloopTransaction` class, which will automatically handle begin/commit, and cancel if an exception is thrown. For this, you have to implement the `execute` method of the `GloopTransaction` class. The transaction will be executed with the start method.

Inline example:

```java
new GloopTransaction() {

    @Override
    public void execute() {
        Person person = new Person();
				person.save();
    }

}.start();
```

Class example:

```java
private class TestTransaction extends GloopTransaction {

    @Override
    public void execute() {
        Person person = new Person();
		person.save();
    }
}
```
To run the transaction

```java
TestTransaction transaction = new TestTransaction();

transaction.start(); 	// to run transaction on default store
or
transaction.start("testStore"); 	// to run transaction on testStore
```

### Nested transactions

It is not allowed to have one transaction inside other transactions. Commit or cancel first one transaction bevor beginning another one. Otherwise it will throw an exception.


### GloopTransactionException

The `GloopTransactionException` is thrown if an error occur in one of the transaction methods. The `GloopTransactionException` is a `RuntimeException` because of this, there is no need for try catch block.

```java
try {
	Gloop.beginTransaction();
} catch (GloopTransactionException e) {
	// do something
}
```
