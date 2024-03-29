package Areno::Page;

use strict;

use base 'Exporter';
our @EXPORT = qw(route new);

sub import {
    my ($this, $args) = @_;

    SUPER->import(@_);
}

sub new {
    my ($class, $site, $areno) = @_;

    my $this = {
        site    => $site,
        areno   => $areno,
        headers => [],
    };
    bless $this, $class;

    return $this;
}

sub route {
    qr{};
}

sub transform {
    'localhost'
}

sub init {
    my ($this, $doc) = @_;

    $this->{headers} = [];
    $this->{doc} = $doc;
}

sub run {

}

sub site {
    my ($this) = @_;
    
    return $this->{site};
}

sub request_uri {
    my ($this) = @_;

    return $this->{areno}{request}{path};
}

sub content {
    my ($this) = @_;

    return $this->{doc}{content};
}

sub contentChild {
    my ($this, $name, $attributes, $text) = @_;

    my $newNode = new XML::LibXML::Element($name);
    $this->{doc}{content}->appendChild($newNode);

    _setNodeValues($newNode, $attributes, $text);

    return $newNode;
}

sub contentTextChild {
    my ($this, $name, $text) = @_;

    my $newNode = $this->contentChild($name);
    $newNode->appendText($text);

    return $newNode;
}

sub manifest {
    my ($this) = @_;

    return $this->{doc}{manifest};
}

sub manifestChild {
    my ($this, $name, $attributes, $text) = @_;

    my $newNode = new XML::LibXML::Element($name);
    $this->{doc}{manifest}->appendChild($newNode);

    _setNodeValues($newNode, $attributes, $text);

    return $newNode;
}

sub manifestTextChild {
    my ($this, $name, $text) = @_;

    my $newNode = $this->manifestChild($name);
    $newNode->appendText($text);

    return $newNode;
}

sub newChild {
    my ($this, $node, $name, $attributes, $text) = @_;
    
    my $newNode = new XML::LibXML::Element($name);
    $node->appendChild($newNode);
    
    _setNodeValues($newNode, $attributes, $text);

    return $newNode;
}

sub newTextChild {
    my ($this, $node, $name, $text) = @_;
    
    my $newNode = new XML::LibXML::Element($name);
    $node->appendChild($newNode);
    $newNode->appendText($text);
    
    return $newNode;
}

sub newItem {
    my ($this, $node, $attributes, $text) = @_;
    
    $this->newChild($node, 'item', $attributes, $text);
}

sub param {
    my ($this, $name) = @_;
    
    my $list = $this->{doc}{request}{arguments}{$name} || [];
    
    return
        ! wantarray
        ? (@$list ? $$list[0] : undef)
        : (@$list ? @$list : ())
        ;
}

sub params {
    my ($this) = @_;
    
    return keys %{$this->{doc}{request}{arguments}};
}

sub cookie {
    my ($this, $name) = @_;
    
    return $this->{doc}{request}{cookies}{$name};
}

sub request {
    my ($this, $name) = @_;

    return $this->{areno}{request}{$name};
}

sub set_header {
    my ($this, @pairs) = @_;

    push @{$this->{headers}}, @pairs;
}

sub set_body {
    my ($this, $body) = @_;

    $this->{body} = $body;
}

sub get_upload {
    my ($this, $name) = @_;

    return $this->{doc}{request}{request}->upload($name);
}

sub get_headers {
    my ($this) = @_;

    return $this->{headers};
}

sub get_stash {
    my ($this) = @_;
    my $stash = $this->{areno}->stash;

    return $stash;
}

sub set_stash_var {
    my $this  = shift;
    my ($key, $value) = @_;
    warn "value in STASH must be SCALAR, not ref (it might be allowed in future)"
        if ref $value;

    my $stash = $this->{areno}->stash;
    my $prev_value = $stash->{$key};
    $stash->{$key} = $value;

    return $prev_value;
}

sub _setNodeValues {
    my ($node, $attributes, $text) = @_;
    
    if (defined $attributes) {
        for my $attribute (keys %$attributes) {
            $node->setAttribute($attribute, $attributes->{$attribute});
        }
    }

    if (defined $text) {
        $node->appendText($text);
    }
}

1;
