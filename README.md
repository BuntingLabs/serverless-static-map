# serverless-static-map

> Render static PNG's of GeoJSON overlayed on top of vector tilesets. Open source
and serverless, ready to be deployed to AWS Lambda.

Built heavily on top of [pymgl](https://github.com/brendan-ward/pymgl), a renderer
that uses `maplibre-gl-native`, this serverless function is especially useful
for embedding maps into ChatGPT responses.

## Getting started

```sh
docker build --platform linux/x86_64 -t staticmap .

docker run -p 9000:8080 --platform linux/x86_64 staticmap
```

## License

MIT licensed
