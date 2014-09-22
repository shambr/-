package Areno::Localhost::All;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    qr{^/all(hidden)?}
}

sub transform {
    'all'
}

sub run {
    my ($this) = @_;

    $this->session();
    
    if ($this->{user}{status} eq 'moderator') {
        $this->list();
    }
}

sub list {
    my ($this) = @_;

    my $is_published = ($this->request_uri() =~ /hidden/) ? 0 : 1;

    my $dbh = get_dbh();

    my $sth = $dbh->prepare("
        select
            id,
            score,
            text,
            name
        from
            questions
        where
            is_published = $is_published and
            is_removed = 0
        order by
            order_id desc,
            score desc,
            datetime desc
    ");
    $sth->execute();

    my $colour = 0;
    my $listNode = $this->contentChild('list');
    while (my ($id, $score, $text, $name) = $sth->fetchrow_array()) {
        next unless $text =~ /\S/;

        $text =~ s{^\s+}{};
        $text =~ s{\s+$}{};
        $text =~ s{ \s+}{ }g;

        $name =~ s{^\s+}{};
        $name =~ s{\s+$}{};
        $name =~ s{ \s+}{ }g;

        $this->newItem($listNode, {
            id => $id,
            score => $score,
            name => $name
        }, $text);
    }
}

__PACKAGE__;
