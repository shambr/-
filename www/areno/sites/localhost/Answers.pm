package Areno::Localhost::Answers;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/answers'
}

sub transform {
    'answers'
}

sub run {
    my ($this) = @_;

    $this->session();

    my ($id) = $this->param('id') =~ /^(\d+)$/a;

    if ($id) {        
        $this->get_question($id);
        $this->get_answers($id);

        if ($this->{user}{status} eq 'moderator') {
            $this->get_users();
        }
    }
}

sub get_question {
    my ($this, $id) = @_;

    my $sth = get_dbh()->prepare("
        select
            datetime,
            name,
            text
        from
            questions
        where
            id = ?
    ");
    $sth->execute($id);

    my ($datetime, $name, $text) = $sth->fetchrow_array();
    $this->contentChild('question', {
        id => $id,
        datetime => $datetime,
        name => $name,
    }, $text);    
}

sub get_answers {
    my ($this, $id) = @_;

    my $sth = get_dbh()->prepare("
        select
            id,
            text,
            name,
            is_published
        from
            answers
        where
            question_id = ? and
            is_removed = 0
        order by
            id desc
    ");
    $sth->execute($id);

    my $answersNode = $this->contentChild('answers');
    while (my ($id, $text, $name, $is_published) = $sth->fetchrow_array()) {
        $text =~ s{\n+}{<br />}g;

        $this->newItem($answersNode, {
            id => $id,
            name => $name,
            is_published => $is_published,
        }, $text);
    }
}

__PACKAGE__;
