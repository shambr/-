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
    my $filter3 = $this->param('filter3') // '';

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
    elsif ($filter1 eq 'interesting') {
        $filter1_sql = 'is_interesting = 1 and is_removed = 0';
    }

    my $filter2_sql = '1';
    $filter2 =~ s{^\s+}{};
    $filter2 =~ s{\s+$}{};
    $filter2 =~ s{  +}{ }g;
    if ($filter2 ne '') {
        my $match = get_dbh()->quote($filter2);
        $filter2_sql = "match(text) against($match)";
    }

    my $filter3_sql = '1';
    $filter3 =~ s{^\s+}{};
    $filter3 =~ s{\s+$}{};
    $filter3 =~ s{  +}{ }g;
    if ($filter3) {
        my $match = get_dbh()->quote($filter3);
        $filter3_sql = "match(tags) against($match)";
    }

    my $dbh = get_dbh();

    my $sth = $dbh->prepare("
        select
            id,
            datetime,
            score,
            text,
            name,
            tags,
            is_published,
            is_removed,
            is_interesting
        from
            questions
        where
            ($filter1_sql) and
            ($filter2_sql) and
            ($filter3_sql)
        order by            
            is_new desc,
            order_id desc,
            datetime desc,
            score desc            
    ");

    $sth->execute();

    my $colour = 0;
    my $listNode = $this->contentChild('list');
    while (my ($id, $datetime, $score, $text, $name, $tags, $is_published, $is_removed, $is_interesting) = $sth->fetchrow_array()) {
        next unless $text =~ /\S/;

        $text =~ s{^\s+}{};
        $text =~ s{\s+$}{};
        $text =~ s{ \s+}{ }g;

        $name =~ s{^\s+}{};
        $name =~ s{\s+$}{};
        $name =~ s{ \s+}{ }g;

        $datetime =~ s{:00$}{};
        my $questionNode = $this->newItem($listNode, {
            id => $id,
            datetime => $datetime,
            score => $score ? sprintf("%+i", $score) : 0,
            name => $name,
            tags => $tags,
            is_published => $is_published,
            is_removed => $is_removed,
            is_interesting => $is_interesting,
            text => $text,
        });

        for my $tag (split /, */, $tags) {
            $tag =~ s{^ +}{};
            $tag =~ s{ +$}{};
            $tag =~ s{ +}{ };

            $this->newItem($questionNode, {
            }, $tag) if $tag =~ /\S/;
        }
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
