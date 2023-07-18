# Yet Another Mission Script

!!! info Work in progress
    This is a very new project and so it may not have all the features you are looking for right now.
    If this is the case I can highly recommend having a look at:

> 
> * [S.S.E - The basic API from Eagle Dynamics](https://wiki.hoggitworld.com/view/Simulator_Scripting_Engine_Documentation#Simulator_Scripting_Engine)
> * [M.O.O.S.E - An extremely powerful solution](https://flightcontrol-master.github.io/MOOSE_DOCS/)
> * [Mist](https://wiki.hoggitworld.com/view/Mission_Scripting_Tools_Documentation)

There are other frameworks that exist too, but these are the three most commonly used in 2023 for english speaking users.

## So ...why YAMS?

To be honest I found most of the above frameworks to be simulaneously awesome and frustration inducing. The primary reason for this
is the accessibility of the documentation in each scenario. 

The SSE docs are scant, the Mist docs are ridden with Ads, and the MOOSE docs, while comprehensive, are extremely difficult to search and learn.

In addition, I was not a fan of the structure and function of these APIs. Rather than try and turn one around, I felt that starting again was simpler for me. Hence the name - Yet Another Mission Script.

!!! warning This is my rifle. 
    There are many others like it, but this one is mine.

## Project Goals

The goal of this project is to provide a mission scripter a well documented set of tools with up to date examples, even if that set of tools is small to begin with.

Rather than solve every problem, the problems that get solved, should...

* Be well documented, with clear examples
* Have a low barrier to entry to achieve the goal of the feature
* Yield a consistent syntax that allows the editor to fall into the 'pit of success' as much as possible

Further, I want the documentation itself to be easy to generate, clean of ads, searchable, and generally easy to use. This is why I chose mkdocs and

## Alright let's get scripting

:sunglasses: Yeah! Head on over to [Getting Started](/getting-started)

## Dependencies

This project only has one dependency: the Simulator Scripting Engine (SSE) which is the standard kit provided by the game - you don't need to install this. Just look for documentation regarding its use in conjunction with other frameworks.

It is useful to know it, as it provides the basic primitives to work with to create complex scripts, like this one, and yours.

For your convenience, I am building a reference for the SSE, [here](/SSE%20Reference)