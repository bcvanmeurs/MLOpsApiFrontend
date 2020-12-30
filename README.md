# mlops_api_test

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
