package Areno::Localhost::Manage;

use strict;
use base 'TheQuestion::Page';

use utf8;
use Datasource;
use Lingua::RU::Numeric::Declension;

sub route {
    '/manage'
}

sub transform {
    'manage'
}

sub run {
    my ($this) = @_;

    $this->session();
    
    if ($this->{user}{status} eq 'moderator') {
        $this->list();
        $this->count_answers();
    }
}

sub list {
    my ($this) = @_;

    my $filter1 = $this->param('filter1') // 'all';
    my $filter2 = $this->param('filter2') // '';

    my $filter1_sql = '1';
    if ($filter1 eq 'all') { 
        $filter1_sql = 'is_removed = 0';       
    }
    elsif ($filter1 eq 'published') {
        $filter1_sql = 'is_published = 1 and is_removed = 0';
    }
    elsif ($filter1 eq 'hidden') {
        $filter1_sql = 'is_published = 0 and is_removed = 0';
    }
    elsif ($filter1 eq 'removed') {
        $filter1_sql = 'is_removed = 1';
    }

    my $dbh = get_dbh();

    my $sth = $dbh->prepare("
        select
            id,
            score,
            text,
            name,
            tags
        from
            questions
        where
            $filter1_sql
        order by            
            is_new desc,
            order_id desc,
            datetime desc,
            score desc            
    ");
    $sth->execute();

    my $colour = 0;
    my $listNode = $this->contentChild('list');
    while (my ($id, $score, $text, $name, $tags) = $sth->fetchrow_array()) {
        next unless $text =~ /\S/;

        $text =~ s{^\s+}{};
        $text =~ s{\s+$}{};
        $text =~ s{ \s+}{ }g;

        $name =~ s{^\s+}{};
        $name =~ s{\s+$}{};
        $name =~ s{ \s+}{ }g;

        $this->newItem($listNode, {
            id => $id,
            score => $score,
            name => $name,
            tags => $tags,
        }, $text);
    }
}

sub count_answers {
    my ($this) = @_;

    my $sth = get_dbh()->prepare("
        select
            question_id,
            count(*)
        from
            answers
        where
            is_published = 1 and
            is_removed = 0
        group by 
            question_id
    ");
    $sth->execute();

    my $answersinfoNode = $this->contentChild('answers-info');
    while (my ($question_id, $count) = $sth->fetchrow_array()) {
        $this->newItem($answersinfoNode, {
            question_id => $question_id,
            count => $count,
            label => Lingua::RU::Numeric::Declension::numdecl($count, 'ответ', 'ответа', 'ответов'),
        });
    }
}

__PACKAGE__;
