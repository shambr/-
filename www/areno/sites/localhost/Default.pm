package Areno::Localhost::Default;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/'
}

sub transform {
    'default'
}

sub run {
    my ($this) = @_;

    $this->session();
    
    $this->list();
}

sub list {
    my ($this) = @_;

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
            is_published = 1 or
            (is_new = 1 and
             session = ?)
        order by            
            is_new desc,
            order_id desc,
            score desc,
            datetime desc
    ");
    $sth->execute($this->{session});

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
