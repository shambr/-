package Areno::Localhost::ToggleStatus;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/toggle_qstatus'
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

    $this->toggle_qstatus($id, $value);
}

sub toggle_qstatus {
    my ($this, $id, $value) = @_;

    my $sth = get_dbh()->prepare("
        update
            questions
        set
            is_published = ?,
            is_removed = 0
        where
            id = ?
    ");
    $sth->execute($value, $id);
}

__PACKAGE__;
