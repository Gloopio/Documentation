---
layout: default
category: obj
title: "Saving Objects"
---

# Save
Any object that subclasses (inherits) `GLPObject` class **OR** adheres to (implements) the 
`<GLPObject>` protocol can be saved by calling the `save` method.

### GLPObject Protocol
#####How can a protocol add methods to a class without me implementing them?
The `<GLPObject>` Protocol is a self-implementing protocol, you should not implement its methods.
The GloopSDK scans for objects that implement the `<GLPObject>` Protocol at runtime, and it adds these methods onto the classes as it finds them.

