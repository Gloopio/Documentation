---
layout: default
category: cor
title: "Permissions"
---

##Permissions
Permissions define who can `read`,`write` and `discover` `GloopObjects`.

Permissions can be set only on an entire `GloopObject`, and nothing smaller. 

Sometimes permissions decide if `GloopObjects` will be stored `locally` and/or `remotely`. 

Permission data is represented exactly like unix, except execute is replace with discover. 

The value stored as a smallint (2 bytes) in postgres/sql, and for now we are only using the first triad (the owner permissions), we keep the others for future expansion, and backward compatibility.

|Symbolic Notation|Octal Notation	|English|
|---|---|---|
|----------|0000|no permissions|
|---d--d--d|0111|discover|
|--w--w--w-|0222|write|
|--wd-wd-wd|0333|write & discover|
|-r--r--r--|0444|read|
|-r-dr-dr-d|0555|read & discover|
|-rw-rw-rw-|0666|read & write|
|-rwdrwdrwd|0777|read, write, & discover|


##Schema
###Remote and local tables

######GloopACL
```SQL
objectId UUID PRIMARY KEY, 
metadata TEXT,
userId UUID,
groupId UUID,
objectUuid UUID,
permission INTEGER,
className TEXT
```

######GloopUser
```SQL
objectId UUID PRIMARY KEY, 
metadata TEXT,
name TEXT NOT NULL,
secret TEXT
```

######GloopGroup
```SQL
objectId UUID PRIMARY KEY, 
metadata TEXT,
name TEXT NOT NULL,
secret TEXT
members TEXT 
```

##Structure

###Users
A `User` can represent anything, for example, a specific `Device` or an `Account`.

**Note:** A `User` itself may also represent many other `Users`, these `sub_users`, are found from the `UserMap` table, see `UserMap` below.


###Groups
Groups make it easy to provide a large amount of `Users` (a group of users) access a GloopObject.

A group is a virutal concept. It is actually just a `User` that has many `subusers`.

**Note:** A subuser may access any `GloopObject` that the `superuser` may access, but the `User` itself that represents the virtual group has no access any any of its `subusers` `GloopObjects`.

###ACL
The ACL table is used to check the permissions of one user/group of a GloopObject. 
The ACL table has a reference to the object. Depending on the owner it also has a reference to the User or the Group. In the permission column the permission is saved as integer value.
##Access Rules
Tom wants to write to GloopObject X.

Is Tom the owner of GloopObject X, and does the owner have write permissions? → **Access Granted**

Is there a group that Tom belongs to, that has write permissions to GloopObject X? → **Access Granted**

Otherwise → **Access Denied**

