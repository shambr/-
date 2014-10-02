package Areno::Localhost::Post;

use strict;
use base 'TheQuestion::Page';

use Datasource;

sub route {
    '/post'
}

sub run {
    my ($this) = @_;

    $this->session();

    $this->post();
    $this->set_header('Location' => "/");
    $this->{areno}{http}{status} = 301;
}

sub post {
    my ($this) = @_;

    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
    $mon++;
    $year += 1900;
    my $datetime = sprintf "%4i-%02i-%02i %02i:%02i", $year, $mon, $mday, $hour, $min, $sec;

    my $ip = $ENV{remote_addr};

    my $question = $this->param('question');

    my $tags = $this->param('tags');
    my $name = $this->param('name');
    my $email = $this->param('email');

    my $impersonate_id = $this->param('impersonate_id') || 0;
    my $user_id = $this->{user}{id} || 0;

    if ($impersonate_id) {
        $name = $this->get_name($impersonate_id);
    }
    elsif ($user_id) {
        $name = $this->get_name($user_id);
    }

    my $sth = get_dbh()->prepare("
        insert into
            questions
            (datetime, ip, name, email, text, tags, session, is_new, user_id, impersonate_id)
        values
            (?, ?, ?, ?, ?, ?, ?, 1, ?, ?)
    ");
    $sth->execute($datetime, $ip, $name, $email, $question, $tags, $this->{session}, $user_id, $impersonate_id);

    $this->set_header('Set-Cookie', "name=$name; Expires=Wed, 09 Jun 2021 10:18:14 GMT");
    $this->set_header('Set-Cookie', "email=$email; Expires=Wed, 09 Jun 2021 10:18:14 GMT");
}

__PACKAGE__;
