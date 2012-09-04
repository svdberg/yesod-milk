# MilkMachine
This is a simple application that keeps track of breast feedings.

The application is build using a ReST backend created in Haskell.
We use the Yesod framework basically because it supports authentication with several ID backends, like GoogleID and Mozilla Personas.

All data is stored in mongoDB, hosted on an amazon EC2 instance.

The front end is built using backbone.js, jquery and twitter bootstrap.

## Building and running
The application is a cabalized haskell package. This means that you can build it using cabal. Install cabal, or better the haskell platform. Now you can run cabal install. This will install the binary in ~/.cabal/bin by default (on a unix type machine). There are two cabal files in the source tree, one for development and one for production. You should remove the one you don't need.

## tech stack
* Haskell
* Yesod
* Yesod persistence
* Yesod Auth
* MongoDB
* backbone.js
* jQuery
* backbone.js paginator

## Contact and usage
You are free to use this code in whatever way you like, although I would like to be mentioned. If you have any questions you can drop me a line using my github profile.