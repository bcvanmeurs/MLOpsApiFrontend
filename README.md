# MLOpsApiFrontend

A small application build in Elm to learn Elm and to showcase interaction with a simple API.

- The Elm app constructs a json object to send to the api based on the selected properties.
- The app displays the response from the server, you can manually enter the API endpoint.
- Formatting is done with bootstrap css because I wanted something 'nice' quick.

## Running in development

Compile javascript

```bash
elm make src/Main.elm --output=main.js
```

Run with elm-live

```bash
elm-live src/Main.elm --open -- --output=main.js
```

## Compile for production

```bash
elm make src/Main.elm --optimize --output=main.js
```
