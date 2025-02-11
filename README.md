This is the code I use to run my *flailing in my kitchen* site. This is just the code to run the site, and it doesn't contain the contents of the blog itself.

This is a web app written in perl using the [Mojolicious](https://www.mojolicious.org) framework.

# Setup
You need to have SQLite installed, and you need to have the blog database set up. I have an SQL dump that contains a small portion of the blog that can be used for testing purposes:

    sqlite3 Food.sqlite < bin/setup_blog_db.sql

Update the app.conf file with the correct path to the database.

Make sure you have perl installed on your system. I use [carton](https://metacpan.org/pod/carton) for managing perl module dependencies. So, figure out how that works.

You'll also have to install the appropriate version of [Mojolicious::Plugin::Blog](https://github.com/meylingtaing/Mojolicious-Plugin-Blog) somewhere. (Check the cpanfile) I use [pinto](https://metacpan.org/dist/Pinto/view/bin/pinto) for this. Then you'll need to update the cpanfile so carton is able to find the module.

Once you've locally installed all the perl modules using carton, you can use this to run the app in development mode:

    carton exec -- morbo bin/webapp.pl
