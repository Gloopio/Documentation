---
layout: default
category: cor
title: "Authentication"
---

# Authentication

Tokens are used to authenticate the user on the server. This is done by the core. The core calls an authentication endpoint on the server. If the user is authenticated successful the server response with a generated token, that will be used for future requests. If the authentication fails the core generates a new user that is used in the future. All objects created are bound to the userId. If an already existing user should be used, then this GloopUser can be saved like a normal GloopObject. The core loads this user at the start and uses this one for future requests.