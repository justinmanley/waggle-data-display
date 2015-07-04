### Waggle Data Display

This application displays incoming data reported by sensors using [Waggle](http://www.mcs.anl.gov/project/waggle-open-platform-intelligent-attentive-sensors), an open platform for environmental sensors created at [Argonne National Lab](http://www.anl.gov/).

This data display application is written in [Elm](http://elm-lang.org/), a functional reactive programming language for web programming.

View a [demo of the data display](). Note that this demo displays randomly generated data, not actual data.

### Development

To run this demo yourself, you'll need to download the [Elm Platform](http://elm-lang.org/install). Once you've set up the Elm Platform, you can build the project by typing at the command line:

```bash
elm make Main.elm
```

You can then view the demo by navigating to the `index.html` file in the root of this repository. An easy way to serve up `index.html` is to run `elm reactor` in the root of this repository. After typing `elm reactor` at the command line, `index.html` will be accessible at `localhost:8000/index.html`.

To connect this demo to a live data source, write the live sensor data to `data/current` each time the sensor is polled. See `data/current.example` for an example of a properly formatted sensor data dump.

Copyright (c) 2015, Justin Manley and Argonne National Laboratory
All rights reserved.

Released under the [GPLv3](http://www.gnu.org/licenses/gpl.html) (see [LICENSE](./LICENSE)).
