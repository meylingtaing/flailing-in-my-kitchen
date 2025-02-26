package App::Controller::Root;
use Mojo::Base 'Mojolicious::Controller';

use Blog;
use Lingua::EN::Inflect qw(WORDLIST);

=head2 get_random_tagline

This is extra logic to generate random tags to diplay in the
"How can I be sad..." tagline

=cut

sub get_random_tagline {
    my $c = shift;

    # XXX If this table grows too large, to make this faster, see
    # https://stackoverflow.com/a/24591688

    my $blog = Blog->new($c->app->config('blog_db_file'));

    # Randomly get a tag that I've designated can appear in the tagline
    my $tag = $blog->{dbh}->selectrow_hashref(qq{
        SELECT tag_id, is_long_tagline, alt_tagline, label
        FROM TaglineTags
        JOIN Tags ON TaglineTags.tag_id = Tags.id
        ORDER BY RANDOM() LIMIT 1
    });

    my @tagline_tags = ({
        tag     => $tag->{label},
        display => $tag->{alt_tagline} || $tag->{label},
    });

    # So I've got long tags and short tags, and if we got a long one, we'll
    # just use that by itself. If we got a short one, we'll grab two more
    if (!$tag->{is_long_tagline}) {
        my @tags = $blog->{dbh}->selectall_array(qq{
            SELECT alt_tagline, label
            FROM TaglineTags
            JOIN Tags ON TaglineTags.tag_id = Tags.id
            WHERE is_long_tagline = 0 and tag_id != ?
            ORDER BY RANDOM() LIMIT 2
        }, { Slice => {} }, $tag->{tag_id});

        for my $extra_tag (@tags) {
            push @tagline_tags, {
                tag     => $extra_tag->{label},
                display => $extra_tag->{alt_tagline} || $extra_tag->{label},
            };
        }
    }

    # Okay, let's html-ify this now, because it's kind of a pain in the butt to
    # do this in a template file
    my $html_tagline_links = WORDLIST(
        map { "<a href='/tag/$_->{tag}'>$_->{display}</a>" } @tagline_tags
    );

    $c->stash(tagline_links => $html_tagline_links);
}

1;
