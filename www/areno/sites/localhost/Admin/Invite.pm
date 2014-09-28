package Areno::Localhost::Admin::Invite;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/admin/invite'
}

sub transform {
    'admin/invite'
}

sub run {
    my ($this) = @_;

    $this->session();

    if ($this->{user}{status} eq 'moderator') {
        my ($question_id) = $this->param('id') =~ /^(\d+)$/a;
        if ($question_id) {
            $this->invite($question_id);
        }
    }
}

sub invite {
    my ($this, $question_id) = @_;

    $this->get_question($question_id);
    $this->userlist();

    my $who = $this->param('who');
    $this->make_link($question_id, $who) if $who;
}

sub get_question {
    my ($this, $question_id) = @_;

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
    $sth->execute($question_id);

    my ($datetime, $name, $text) = $sth->fetchrow_array();
    $this->contentChild('question', {
        id => $question_id,
        datetime => $datetime,
        name => $name,
    }, $text);
}

sub userlist {
    my ($this) = @_;

    my $usersNode = $this->contentChild('users');
    my $sth = get_dbh()->prepare("
        select
            id,
            firstname,
            lastname
        from
            users
        order by
            firstname,
            lastname
    ");
    $sth->execute();

    while (my ($id, $firstname, $lastname) = $sth->fetchrow_array()) {
        $this->newItem($usersNode, {
            id => $id,
            firstname => $firstname,
            lastname => $lastname,
        });
    }
}

sub make_link {
    my ($this, $question_id, $who) = @_;

    my $sth = get_dbh()->prepare("
        select
            code
        from
            asking
        where
            question_id = ? and
            user_id = ?
    ");
    $sth->execute($question_id, $who);

    my ($code) = $sth->fetchrow_array();

    unless ($code) {
        $code = '';
        for (0..10) {
            $code .= chr(int(rand(25) + 65));
        }

        $sth = get_dbh()->prepare("
            insert into
                asking
                (question_id, user_id, code)
            values
                (?, ?, ?)
        ");
        $sth->execute($question_id, $who, $code);
    }

    $this->contentChild('link', {}, "http://thequestion.ru/of/$code");
}

__PACKAGE__;
