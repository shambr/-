package Areno::Localhost::Remove;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/remove'
}

sub run {
    my ($this) = @_;

    $this->session();

    $this->remove();
}

sub remove {
    my ($this) = @_;

    return unless $this->{user}{status} eq 'moderator';

    my ($id) = $this->param('id') =~ /^(\d+)$/a;

    if ($id) {
        my $sth = get_dbh()->prepare("
            update
                questions
            set
                is_published = 0,
                is_removed = 1,
                is_new = 0
            where
                id = ?
        ");
        $sth->execute($id);
    }
}

__PACKAGE__;
