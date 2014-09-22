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
}


__PACKAGE__;
