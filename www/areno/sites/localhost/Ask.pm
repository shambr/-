package Areno::Localhost::Ask;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/ask'
}

sub transform {
    'ask'
}

sub run {
    my ($this) = @_;

    $this->session();

    $this->contentTextChild('ask', '');

    if ($this->{user}{status} eq 'moderator') {
        $this->get_users();
    }
}


__PACKAGE__;
