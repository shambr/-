package Areno::Localhost::Vote;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/vote'
}

sub run {
    my ($this) = @_;

    $this->session();

    $this->vote();
}

sub vote {
    my ($this) = @_;

    my ($id) = $this->param('id') =~ /^(\d+)$/a;
    my ($vote) = $this->param('vote') =~ /^([pm])$/;

    if ($id && $vote) {
        my $value = $vote eq 'p' ? '+ 1' : '- 1';

        my $sth = get_dbh()->prepare("
            update
                questions
            set
                score = score $value
            where
                id = ?
        ");
        $sth->execute($id);
    }
}

__PACKAGE__;
