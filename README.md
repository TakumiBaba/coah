# coah

![](https://raw2.github.com/geta6/coah/master/app/assets/img/coah.png)

![](https://travis-ci.org/geta6/coah.png)

coah, node.js WAF template.

## requirement

* node.js
* mongodb

## about

:-)          | details
-------------|-------------------------------
`coffee`     | lint -> build -> minimize
`stylus`     | build -> lint -> minimize
`jade`       | build -> lint -> minimize
`image`      | minimize image (jpg, png, gif)
`copy`       | copy static files
`test`       | test with mocha
`notify`     | fail notification
`concurrent` | concurrent unordered task
`println`    | print coffee-script error lineno


## install

    git clone https://github.com/geta6/coah
    cd coah
    npm i

## config

    cp config/env.json{.sample,}

## grunt tasks

### build

  grunt build your assets.

    grunt build

### test

  grunt exec your test by mocha.

    grunt test

### server

  grunt run `config/app.coffee`.

    grunt server

### watch

  grunt watch and build your assets.

    grunt watch

### build -> test -> server -> watch

  grunt exec all tasks.

    grunt all

### build -> test -> watch

  grunt exec tasks for assets.

    grunt


## npm

### test

  run grunt build before starting server.

    $ npm test

    # is equal to

    $ grunt build
    $ grunt test

### start

  run grunt build before starting server, not watch.

    $ npm start

    # is equal to

    $ grunt build
    $ grunt server


## MIT LICENSE

Copyright &copy; 2014 geta6 licensed under [MIT](http://opensource.org/licenses/MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
