#!/usr/bin/perl -w

use v5.12;
use Getopt::Std;
use Data::Dumper;
use DBI;
use Text::CSV;

use strict;

my $USAGE = <<"END";
Usage:
$0 [options] <command> [args]

Options:
 -h : help
 -v : verbose
 -p <path> : path to database (default: current directory)
Commands:
 query  <query>
 export <query>
 import <table> <file>
 stats  <table>
END

sub usage {
    my $error = shift;
    print "ERROR: $error\n" if $error;
    print $USAGE;
    exit !!$error;
}

our($opt_h, $opt_v);
our $opt_p = '.';
our $opt_r = chr(0x1E); # Record separator, NOT USED
our $opt_f = chr(0x1F); # Field  separator, NOT USED
getopts('hp:v');
usage if $opt_h;

$opt_r = chr(hex($opt_r)) if ($opt_r =~ /^0x/);
$opt_f = chr(hex($opt_f)) if ($opt_f =~ /^0x/);


sub cmd_query {
    my $query = shift;
    my $dbh = DBI->connect("DBI:XBase:".$opt_p) or die $DBI::errstr;
    my $sth = $dbh->prepare($query) or die $dbh->errstr();
    $sth->execute() or die $sth->errstr();
    my $rows = $sth->rows;
    print "Query executed. $rows rows affected.\n";
    
    while (my @row = $sth->fetchrow_array()) {
        print join(";", @row)."\n";
    }
    $sth->finish();
    $dbh->disconnect();
}


sub cmd_export {
    my $query = shift;
    my $dbh = DBI->connect("DBI:XBase:".$opt_p) or die $DBI::errstr;
    my $csv = Text::CSV->new({ binary => 1, auto_diag => 1, eol => $/});

    my $sth = $dbh->prepare($query) or die $dbh->errstr();
    $sth->execute() or die $sth->errstr();
    
    $csv->print(\*STDOUT, $sth->{NAME});

    while (my $row = $sth->fetchrow_arrayref()) {
        $csv->print(\*STDOUT, $row);
    }
    $sth->finish();
    $dbh->disconnect();
}


sub cmd_import {
    my $table = shift;
    my $file = shift;
    
    my $dbh = DBI->connect("DBI:XBase:".$opt_p) or die $DBI::errstr;
    open my $fh, "<:raw", $file or die "Failed to open $file: $!";
    my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

    my $headers = $csv->getline($fh);
    my $fields   = join ",", @$headers;
    my $placeholders = join ",", ("?") x scalar @$headers;
    my $sql = "INSERT INTO $table ($fields) VALUES ($placeholders)";
    my $sth = $dbh->prepare($sql);
    
    while (my $row = $csv->getline($fh)) {
        $sth->execute(@$row) or warn $sth->errstr;
    }

    $sth->finish();
    $dbh->disconnect();
    close $fh;
}


sub cmd_stats {
    my $table = shift;
    my $dbh = DBI->connect("DBI:XBase:".$opt_p) or die $DBI::errstr;

    my $sth = $dbh->prepare("select * from $table") or die $dbh->errstr();
    $sth->execute() or die $sth->errstr();

    my @cnt;
    while (my @row = $sth->fetchrow_array()) {
        foreach (@row) { ++$cnt[ord $_] foreach (split '', $_); }
    }
    while (my ($idx, $val) = each @cnt) {
        say "$idx: $val";
    }
}


my $cmd = shift @ARGV;
if ('query' eq $cmd) {
    my $query = shift @ARGV;
    usage "query requires query string" unless $query;
    cmd_query $query;
} elsif ('export' eq $cmd) {
    my $query = shift @ARGV;
    usage "export requires query string" unless $query;
    cmd_export $query;
} elsif ('import' eq $cmd) {
    my ($table, $file) = @ARGV;
    usage "import requires table and file names" unless $file;
    cmd_import($table, $file);
} elsif ('stats' eq $cmd) {
    my $table = shift @ARGV;
    usage "stats command requires table name" unless $table;
    cmd_stats $table;
} else {
    usage "Invalid command '$cmd'";
}

