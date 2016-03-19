# BB8 Microsoft Band Controller

This is just a side project I'm working on for the fun of it.
I'm trying to connect my BB8 to my Microsoft Band to control it with "the force".
At the time of this writing, the native iOS sphero sdk framework didn't support bb8, so I have to write a server to control it in node.js as an intermediate.

That means the communication is: ```Band -> iOS -> node.js```, which is less than ideal. Starting with crude rest calls for the POC, but plan to move to streaming data.