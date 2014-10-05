package Areno::Localhost::Answer;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/answer'
}

sub transform {
    'answer'
}

sub run {
    my ($this) = @_;

    $this->session();

    my ($id) = $this->param('id') =~ /^(\d+)$/a;

    if ($id) {
        my ($user_id, $name) = $this->whoisit();

        if ($user_id) {
            $this->get_question($id);
            $this->get_answer($id, $user_id);
            $this->contentTextChild('answer', '');
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

sub get_answer {
    my ($this, $question_id, $user_id) = @_;

    my $sth = get_dbh()->prepare("
        select
            text
        from
            answers
        where
            question_id = ? and
            user_id = ? and
            is_removed = 0
        order by
            id desc
        limit
            1
    ");
    $sth->execute($question_id, $user_id);

    my ($text, $tags) = $sth->fetchrow_array();

    $this->contentChild('saved-answer', {}, $text // '');
}

sub whoisit {
    my ($this) = @_;

    my $knownas = $this->cookie('knownas');
    return (0, '') unless $knownas;

    my $sth = get_dbh()->prepare("
        select
            id,
            firstname,
            lastname
        from
            users
        where
            knownas = ?
    ");
    $sth->execute($knownas);
    my ($id, $firstname, $lastname) = $sth->fetchrow_array();

    if ($id) {
        $this->manifestChild('known-name', {
            id => $id,
            firstname => $firstname,
            lastname => $lastname,
        }, "$firstname $lastname");
        return ($id, "$firstname $lastname");
    }
    else {
        return (0, '');
    }
}

__PACKAGE__;
