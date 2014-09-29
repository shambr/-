package Areno::Localhost::EditAnswer;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/editanswer'
}

sub transform {
    'editanswer'
}

sub run {
    my ($this) = @_;

    $this->session();
    return unless $this->{user}{status} eq 'moderator';

    my ($id) = $this->param('id') =~ /^(\d+)$/a;
    my ($edit_id) = $this->param('edit_id') =~ /^(\d+)$/a;

    if ($id) {
        $this->get_answer($id);
    }
    if ($edit_id) {
        my $question_id = $this->get_question_id($edit_id);
        $this->edit_answer($edit_id);

        $this->set_header('Location' => "/answers?id=$question_id");
        $this->{areno}{http}{status} = 301;
    }
}

sub get_answer {
    my ($this, $id) = @_;

    my $sth = get_dbh()->prepare("
        select
            name,
            text,
            is_published
        from
            answers
        where
            id = ?
    ");
    $sth->execute($id);
    my ($name, $text, $is_published) = $sth->fetchrow_array();

    $this->contentChild('answer', {
        id => $id,
        name => $name,
        is_published => $is_published,
    }, $text);
}

sub get_question_id {
    my ($this, $id) = @_;

    my $sth = get_dbh()->prepare("
        select
            question_id
        from
            answers
        where
            id = ?
    ");
    $sth->execute($id);
    my ($question_id) = $sth->fetchrow_array();

    return $question_id;
}

sub edit_answer {
    my ($this, $id) = @_;

    my $name = $this->param('name');
    my $text = $this->param('answer');
    my $is_published = ($this->param('is_published') eq 'yes') ? 1 : 0;

    my $sth = get_dbh()->prepare("
        update
            answers
        set
            name = ?,
            text = ?,
            is_published = ?
        where
            id = ?
    ");
    $sth->execute($name, $text, $is_published, $id);
}

__PACKAGE__;
