package MarkdownEnhancements;

use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = qw(process_pre_markdown process_post_markdown);

=head1 NAME

MarkdownEnhancements

=head1 DESCRIPTION

Provides functions for using my custom markdown/html for the
Flailing in my Kitchen website

=cut

sub process_pre_markdown {
    my ($content, %params) = @_;

    my $truncate = $params{truncate};
    my $rss      = $params{rss};

    # Look for <tooltip> and convert to a <span> with class tooltip
    if ($rss) {
        $content =~ s/<tooltip "(.*?)">(.*?)<\/tooltip>/$2 ($1)/mgs;
    }
    else {
        $content =~ s/<tooltip "(.*?)">(.*?)<\/tooltip>/<span class="tooltip-hover">$2<span class="tooltip">$1<\/span><\/span>/mgs;
    }

    return $content;
}

sub process_post_markdown {
    my ($content, %params) = @_;

    # Add captions to images. This'll be...hack-y
    $content =~
        s/<p>(<img\ src=.*?)<\/p>\n\n   # Look for img tag
          <p>\^\ (.*?)<\/p>             # with the next section starting with ^
         /<figure>$1<figcaption><em>$2<\/em><\/figcaption><\/figure><p><\/p>
         /mgx;

    return $content;
}
