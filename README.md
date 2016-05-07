
ansme [![Code Climate](https://codeclimate.com/github/ipcross/ansme/badges/gpa.svg)](https://codeclimate.com/github/ipcross/ansme) [![Build Status](https://travis-ci.org/ipcross/ansme.svg?branch=master)](https://travis-ci.org/ipcross/ansme) [![Test Coverage](https://codeclimate.com/github/ipcross/ansme/badges/coverage.svg)](https://codeclimate.com/github/ipcross/ansme/coverage)
=========

A question and answer service similar to [StackOverflow](http://stackoverflow.com/)

## Installation

1. First clone the [repository from GitHub](https://github.com/ipcross/ansme):

    ```
    git clone git://github.com/ipcross/ansme.git
    ```
    
2. Install all dependencies with:

    ```
    bundle install
    ```
    
3. Copy config/database.yml.example to config/database.yml and edit this file in order to configure your database settings.

    ```
    cp config/database.yml.example config/database.yml
    ```
    
4. Create the database structure, by running the following command under the application root directory:

    ```
    bundle exec rake db:migrate
    ```
    
5. Test the installation by running WEBrick web server:

    ```
    bundle exec rails server
    ```
    
    After that you're almost ready to go.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

[Vitaly Kurennov](https://github.com/vkurennov)  [Vladimir Dementyev](https://github.com/palkan)  
Thanks to all our [awesome
contributors](https://github.com/ipcross/ansme/graphs/contributors)

## Copyright

Copyright (c) 2016 Dmitry Alifanov. See MIT-LICENSE for details.
