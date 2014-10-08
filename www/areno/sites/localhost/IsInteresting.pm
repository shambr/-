package Areno::Localhost::IsInteresting;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/toggle_interesting'
}

sub transform {
    'empty'
}

sub run {
    my ($this) = @_;

    $this->session();
    return unless $this->{user}{status} eq 'moderator';


    my ($value) = $this->param('v') =~ /^([01])$/;
    my ($id) = $this->param('id') =~ /^(\d+)$/a;

    return unless defined $value;
    return unless $id;

    $this->toggle_interesting($id, $value);
}

sub toggle_interesting {
    my ($this, $id, $value) = @_;

    my $sth = get_dbh()->prepare("
        update
            questions
        set
            is_interesting = ?
        where
            id = ?
    ");
    $sth->execute($value, $id);
}

__PACKAGE__;
