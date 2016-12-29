---
layout: default
category: jav
title: "Relationships"
---

# Relationships

Any two GloopObjects can be linked together.

```java
public class Person extends GloopObject {
	private String name;
}
```

```java
public class Address extends GloopObject {
	private String street;
}
```

## Many-to-One
Simply declare a property email from type of one of your GloopObjects.

```java
public class Person extends GloopObject {
	private String name;
	private Email email;
}
```


## Many-to-Many
Simply add a collection containing on or more of your GloopObjects. It is possible to use all basic java collections or create your own serializer instead of List. Recommended is to use GloopList because of performance.

```java
public class Person extends GloopObject {
	private String name;
	private List<Email> email;
}
```

It is possible to declare recursive relationships.

```java
public class Person extends GloopObject {
	private String name;
	private List<Person> friends;
}
```