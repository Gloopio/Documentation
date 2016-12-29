---
layout: default
category: gen
title: "Basics"
---

#Gloop basics

Gloop is a Data mangement platform that makes it easy to do complex tasks.

## Components
###GloopSDK
The GloopSDK is the client library that runs nativly on iOS and Android.

######GloopCore
Part of the GloopSDK, GloopCore is a C++ client library that runs inside of the GloopSDK.

######GloopSDK-iOS
Part of the GloopSDK, GloopSDK-iOS is a native language wrapper for Objective-C around the GloopCore.

######GloopSDK-Android
Part of the GloopSDK, GloopSDK-Android is a native language wrapper for Java around the GloopCore.

###GloopBackend
The GloopBackend is everything that runs server side.
######GloopContainer
Part of the GloopBackend, this is a Go-lang based docker image that processes and stores the data in the GloopDatabase.
######GloopDatabase
A Postgr





#System Architecture

![Gloop Stack](../../images/general/System%20Architecture.svg)