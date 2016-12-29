---
layout: default
category: jav
title: "aspects"
---

# Permissions 

### GloopPermission:

`WRITE, READ`

### GloopUser

A GloopUser is created when the app runs the first time, this user is used to authenticate on the server and to check which objects can be accessed by this user. It is also possible to override this user with an already existing one. The core checks if there is already a user saved otherwise it creates a new one. To get the user from the sdk or to create a new one simply use the GloopUser object that can be handled as a normal GloopObject.

Get the user: `Gloop.all(GloopUser.class).first()`

### GloopGroup

GloopGroup is a Subclass of GloopUser. In addition it contains a list of GloopUsers. It is used to group users together and let them have the same rights to access or modify the object. This will allow users to share there objects.

### GloopACL

To each GloopObject a GloopACL table is generated. Using this tables it is possible to determine who can read or write to objects. This is done within the sdk. Before saving a GloopACL is created and saved and before loading the object the ACL table is loaded. (Will be move to the core)

### GloopObject

`gloopObject.setUser(GloopUser user)`			// set the User that will have access to this object.
`gloopObject.setPermission(int permission)`	// if no permissions set then default permissions are set.

or 

`gloopObject.setUser(GloopGroup group)` // set the Group that will have access to this object.
