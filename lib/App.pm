package App;
use Mojo::Base 'Mojolicious';

sub startup {
    my $app = shift;

    my $config = $app->plugin('Config');

    $app->plugin('Mojolicious::Plugin::Blog');
    $app->config( hypnotoad => { listen => ['http://*:' . $config->{port}] } );
    $app->defaults(db => $config->{blog_db_file});

    my %default = (
        page      => 0,
        template  => 'food_blog',
        direction => 'backwards',
		truncate  => 1,
    );

    my $all_routes = $app->routes;

    $all_routes->get('/')->to('blog#blog', %default);
    $all_routes->get('/rss')->to('blog#rss');
    $all_routes->get('/about');

    # Uh, this feels real hack-y, but I want to be able to get a random tag
    # on pretty much every page. So we're gonna have this action run before
    # all the other actions
    my $r = $all_routes->under('/')->to('root#get_random_tagline');

    $r->get('/tag/:tag/:page')->to('blog#blog', %default);
    $r->get('/about');
    $r->get('/rss')->to('blog#rss');

    $r->get('/entry/:id')->to('blog#blog_entry',
        template => 'food_blog_entry',
    );

    $r->get('/random')->to('blog#random_blog_entry',
        template => 'food_blog_entry',
        include_entry_links => 1,
    );

    $r->get('/search')->to('blog#search',
        %default,
        template => 'search',
    );

    $r->get('/:direction/:page')->to('blog#blog', %default);
}

1;
