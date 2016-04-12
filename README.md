# BB8 Microsoft Band Controller

This is just a side project I'm working on for the fun of it. It's also quite in progress, and I work on it whenever I have a spare hour.

I'm trying to connect my BB8 to my Microsoft Band to control it with "the force".
At the time of this writing, the native iOS sphero sdk framework didn't support bb8, so I have to write a server to control it in node.js as an intermediate.

That means the communication is: ```Band -> iOS -> node.js```, which is less than ideal. Starting with crude rest calls for the POC, but plan to move to streaming data.

### How to run it:
- You need a working copy of ```node.js``` (get it from homebrew or something along those lines)
- You need to install the noble package from Terminal ```npm install sphero noble```
- You need to find your BB8's UUID. [Instructions here](https://www.npmjs.com/package/sphero#connecting-to-bb-8ollie).
- Replace it [in code in the discovery route](/server/app/routes/droid.js)
- First run ```npm install```
- Run the server on your computer with ```npm start```
- To run the iOS client, you need [CocoaPods](https://cocoapods.org/).
- In terminal, from the ```ios``` folder, run ```pod install```
- Open the Workspace (not the Project) with Xcode.
- Build, and deploy to a ***real*** device.

### Limitations & Assumptions
- Server is only supported on OSX
- The band is worn upside down (screen facing on the same side as your palm).
- The server needs to be run first, and currently, restarted everytime the application is launched.
