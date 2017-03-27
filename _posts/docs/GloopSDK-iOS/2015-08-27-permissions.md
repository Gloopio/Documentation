---
layout: default
category: obj
title: "Permissions"
---

# Permissions
When sharing data remotely, permissions must be granted to ensure that everyone can access their data, but cannot access other peoples.

Permissions are made up of a combination of users, groups and `ACLs` (Access Control Lists).
Every GloopObject has an `owner` (which is the user/group that owns the object), and an `ACL` (that defimes which users/groups can read/write to that object).

## Users
Users in Gloop are a powerful concept, a user could represent anything, from just one device, to a whole account, or even the entire world.

Every user has a universally unique `userID`, which looks something like:
`847d9117-cfaf-4c16-b45b-5781acfd1151`

### The current user
The current user is automatically created when your application is first run, it will always be the same unless your application has been uninstalled, or if the current user has been manually changed.

When a GloopObject is created, its owner is always set to the current user.

##ACLs
### Default ACL
The default `ACL` for a GloopObject can be visualised like this:

|user|permissions|
|---|---|
|owner|QUERY \| READ \| WRITE \| WRITE\_ACL \| WRITE\_OWNER|
|everyone|0|

This `ACL` gives full access to the `owner` (by default the current device) and no access to anyone else. `WRITE_ACL` and `WRITE_OWNER` permit a user to modify that objects `ACL` and owner respectively.


### Giving other users permissions
Another user can be added to an `ACL` by adding their userId and the permissions granted.

```Objective-c
Dog *aDog = [Dog new]; // Dog is a subclass of GLPObject
[[aDog acl] addUserByUserID:@"2bdb0830-3250-4d43-a4c8-8ead3be44a88" withPermissions:QUERY|READ|WRITE];
```
The new `ACL` will now look like this:

|user|permissions|
|---|---|
|owner|QUERY \| READ \| WRITE \| WRITE\_ACL \| WRITE\_OWNER|
|everyone|0|
|2bdb0830-3250-4d43-a4c8-8ead3be44a88|QUERY \| READ \| WRITE|


Although there is a owner for every GloopObject, there is no real differance between owning an object or just having access to it. 
## Groups
A group represents a collection of users, (but from a technical standpoint, groups and users are interchangable).

With groups, we can give permissions to access a GloopObject to many users at once. 

```Objective-c
GLPGroup *aGroup = [GLPGroup groupWithUsers:@"2bdb0830-3250-4d43-a4c8-8ead3be44a88",@"847d9117-cfaf-4c16-b45b-5781acfd1151"];

Dog *aDog = [Dog new]; // Dog is a subclass of GLPObject
[[aDog acl] addUser:aGroup withPermissions:QUERY|READ|WRITE];
```
### Group ACLs
Groups themselves also have `ACLs`, and they are exactly the same as GloopObject `ACLs`, this might get confusing, but heres an example:

```Objective-c
GLPGroup *aGroup = [GLPGroup groupWithUsers:@"2bdb0830-3250-4d43-a4c8-8ead3be44a88",@"847d9117-cfaf-4c16-b45b-5781acfd1151"]; 
// A group is created with two users

[[aGroup acl] addUser:aGroup withPermissions:QUERY|READ|WRITE];
// The group gives members of itself permission to modify itself

```
Now the two users in the group can add other users to the group (but the two users cannot give other users the permission to add other users, as they do not have the `WRITE_ACL` permission)!

