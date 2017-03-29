# oauth2-code-flow


Show code flow using Elm.


After successful login access token is stored in the local storage. So next time you visit this app it will
say you are logged in.

Notice: I don't handle expired tokens in this app but this should be trivial to implement.


To learn more on OAuth2 Code read [this](https://tools.ietf.org/html/rfc6749#section-4.1)


## Server

Server part is taken from [http://github.com/prose/gatekeeper](http://github.com/prose/gatekeeper) and just adopted to my needs


## How to run?

Register an application with GitHub and put ClientID and Client Secret into the `server/config.json`
Also add ClientId into `Models.elm`, line 44

Start server with:

1. Open a terminal
2. `cd server`
3. `yarn` - this will install all dependencies
4. `node server.js`

Server is listening on port 9999

Start client with:

1. Open another terminal
2. `yarn` (this will install all dependencies)
3. `yarn start` - this will run the Webpack in development mode on port 8000
