package Areno::Localhost::PostAnswer;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/postanswer'
}

sub transform {
    'postanswer'
}

sub run {
    my ($this) = @_;

    $this->session();

    my ($user_id, $name) = $this->whoisit();

    if ($user_id) {
        my ($answer_to) = $this->param('answer_to') =~ /^(\d+)$/a;
        if ($answer_to) {
            $this->save_answer($user_id, $answer_to);
        }

        $this->set_header('Location' => "/answers?id=$answer_to");
        $this->{areno}{http}{status} = 301;
    }
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

sub save_answer {
    my ($this, $user_id, $answer_to) = @_;

    my $ip = $ENV{remote_addr};

    my ($name) = $this->param('name');
    my ($answer) = $this->param('answer');
    my ($impersonate_id) = $this->param('impersonate_id') || 0;

    $name = $this->get_name($impersonate_id || $user_id) unless $name;

    my $sth = get_dbh->prepare("
        insert into
            answers
            (datetime, ip, name, question_id, text, user_id, impersonate_id)
        values
            (now(), ?, ?, ?, ?, ?, ?)
    ");
    $sth->execute($ip, $name, $answer_to, $answer, $user_id, $impersonate_id);
}


__PACKAGE__;
