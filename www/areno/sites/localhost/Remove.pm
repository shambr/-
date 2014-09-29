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
    return unless $this->{user}{status} eq 'moderator';


    my $type = $this->param('type') // 'question';
    my ($id) = $this->param('id') =~ /^(\d+)$/a;

    return unless $id;

    if ($type eq 'question') {
        $this->remove_question($id);
    }
    elsif ($type eq 'answer') {
        $this->remove_answer($id);
    }
}

sub remove_question {
    my ($this, $id) = @_;
    
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

sub remove_answer {
    my ($this, $id) = @_;
    
    my $sth = get_dbh()->prepare("
        update
            answers
        set
            is_published = 0,
            is_removed = 1
        where
            id = ?
    ");
    $sth->execute($id);
}

__PACKAGE__;
