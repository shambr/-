package Areno::Localhost::Edit;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/edit'
}

sub transform {
    'edit'
}

sub run {
    my ($this) = @_;

    $this->session();

    if ($this->{user}{status} eq 'moderator') {
        my ($save_id) = $this->param('save_id') =~ /^(\d+)$/a;
        $this->update_question($save_id) if $save_id;

        my ($edit_id) = $this->param('id') =~ /^(\d+)$/a;
        $this->get_question($edit_id) if $edit_id;
    }
}

sub get_question {
    my ($this, $id) = @_;

    if ($id) {
        my $sth = get_dbh()->prepare("
            select
                name,
                email,
                text,
                tags,
                score,
                is_published
            from
                questions
            where
                id = ?
        ");
        $sth->execute($id);

        my ($name, $email, $text, $tags, $score, $is_published) = $sth->fetchrow_array();
        $this->contentChild('question', {
            id => $id,
            name => $name,
            email => $email,
            tags => $tags,
            score => $score,
            is_published => $is_published,
        }, $text);
    }
}

sub update_question {
    my ($this, $id) = @_;

    my $text = $this->param('question');
    my $tags = $this->param('tags');
    my $name = $this->param('name');
    my $email = $this->param('email');
    my $is_published = $this->param('is_published') eq 'yes' ? 1 : 0;

    my $sth = get_dbh()->prepare("
        update
            questions
        set
            text = ?,
            tags = ?,
            name = ?,
            email = ?,
            is_published = ?,
            is_new = 0
        where
            id = ?
    ");
    $sth->execute($text, $tags, $name, $email, $is_published, $id);

    $this->make_top_question($id) if $is_published;

    my $url = $is_published ? '/' : '/allhidden';
    $this->set_header('Location' => "$url#$id");
    $this->{areno}{http}{status} = 301;
}

sub make_top_question {
    my ($this, $id) = @_;

    my $max_order_id = $this->get_max_order_id();

    my $sth = get_dbh()->prepare("
        update
            questions
        set
            order_id = ?
        where
            id = ?
    ");
    $sth->execute($max_order_id + 1, $id);
}

sub get_max_order_id {
    my ($this) = @_;

    my $sth = get_dbh()->prepare("
        select
            max(order_id)
        from
            questions
    ");
    $sth->execute();
    my ($max_order_id) = $sth->fetchrow_array();

    return $max_order_id;
}

__PACKAGE__;
