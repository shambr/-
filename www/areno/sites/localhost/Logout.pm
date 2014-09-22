package Areno::Localhost::Logout;

use strict;
use base 'Areno::Page';

use Datasource;

sub route {
    '/logout'
}

sub transform {
    'logout'
}

sub run {
    my ($this) = @_;
    
    $this->logout();
}

sub logout {
    my ($this) = @_;

    my $session = $this->{session};

    $this->set_header('Set-Cookie', 'session=; Expires=Thu, Jan 01 1970 00:00:00 UTC;');
}

__PACKAGE__;
