#!/usr/bin/perl



##!/bin/bash
#
#for i in $(cat 1); do
#ID=$(echo $i|awk -F'-' '{print $1}')
#TITLE=$(echo $i|awk -F'-' '{print $2}')
#CHAODAI=$(echo $i|awk -F'-' '{print $3}')
#AUTHOR=$(echo $i|awk -F'-' '{print $4}')
#
##for j in KR1h0004/*.txt; do
#for j in $ID/*.txt; do
#echo "perl -C $j $ID $TITLE $CHAODAI $AUTHOR"
#perl /root/y.pl "$j" $ID $TITLE "$CHAODAI" $AUTHOR
#done
#
#done

use strict;
#use utf8;
use Encode;
#use warnings;
# perl -C to avoid 'Wide character in print'

my $filename = $ARGV[0];
my $id = $ARGV[1];
my $title = $ARGV[2];
my $dynasty= $ARGV[3];
my $author = $ARGV[4];

my $sectionid;
my @array=split("_",$filename);
$sectionid = @array[-1];
$sectionid =~ s/\.txt//g;

# MODIFY HERE
my $type = "集";

#print "id: $id\n";
#print "type:$type\n";
#print "sectionid:$sectionid\n";
#print "author:$author\n";
#print "dynasty: $dynasty\n";
#print "title: $title\n";


my $line;
my $body;
my $is_last;

my $last_char;
our $length;
#use DBI;
#my $dbh = DBI->connect("DBI:mysql:database=denglou;host=127.0.0.1", "root", 'nobody', {'RaiseError' => 1});

open(my $fh, $ARGV[0]) or die "无法打开待统计文件。\n";

while (my $row = <$fh>) {
    if (eof($fh)) {
        $is_last="1";
    }
    chomp $row;
    if ($row =~ /^[^(]+\).+\([^)]+$/) {
        #print "type A\n";
        #情豈欲亂)隱其名姓(與時沉浮與俗同流而人不知隱之至也)有道則隱無道則見(時之有道
        #print "OLD: $row\n";
        #print "($row)\n\n";
        $line="($row)";
    }elsif ($row =~ /^[^(]+\).*/) {
        #print "type B\n";
        ##情豈欲亂)隱其名姓
        #print "OLD: $row\n";
        #print "($row\n\n";
        $line="($row";
    }elsif ($row =~ /^.*\([^)]+$/) {
        #print "type C\n";
        #print "OLD: $row\n";
        #print "$row)\n\n";
        $line="$row)";
    }else {
#    print "$row\n";
        $line=$row;
    }

    my $a=length($line);
    #print "Length $a - $length \n";
    # single line more than 600/3
    if ($a > 600) {
           #print "INSERT DB A: $line\n";
           $body .= "$line";
           #print "\n,$id,$type,$sectionid,$author,$dynasty,$title,$body\n";
#           $dbh->do("INSERT INTO denglou (`repoid`,`type`,`sectionid`,`author`,`dynasty`,`title`,`body`) VALUES(?,?,?,?,?,?,?)",undef,$id,$type,$sectionid,$author,$dynasty,$title,$body);
print("INSERT INTO denglou (`repoid`,`type`,`sectionid`,`author`,`dynasty`,`title`,`body`) VALUES(\"$id\",\"$type\",\"$sectionid\",\"$author\",\"$dynasty\",\"$title\",\"$body\");\n");
           $body="";
           $length=0;
           next;

    }
    # multiple lines
    if ($length < 600) {
        if ($is_last == "1") {
           #$line=~s/\(/\<span\>/g;
           #$line=~s/\)/\<\/span>/g;
           $body .= "$line";
           #print "INSERT DB B: $body\n";
           #print "\n,$id,$type,$sectionid,$author,$dynasty,$title,$body\n";
#           $dbh->do("INSERT INTO denglou (`repoid`,`type`,`sectionid`,`author`,`dynasty`,`title`,`body`) VALUES(?,?,?,?,?,?,?)",undef,$id,$type,$sectionid,$author,$dynasty,$title,$body);
print("INSERT INTO denglou (`repoid`,`type`,`sectionid`,`author`,`dynasty`,`title`,`body`) VALUES(\"$id\",\"$type\",\"$sectionid\",\"$author\",\"$dynasty\",\"$title\",\"$body\");\n");
           #print "EOF INSERT\n";
           $body="";
           $length=0;

        }else{
           #print "\n,$id,$type,$sectionid,$author,$dynasty,$title,$body\n";
           #print "CONTINUE - $body\n ";
           $length+= $a;
           #$line=~s/\(/\<span\>/g;
           #$line=~s/\)/\<\/span>/g;
           $body .= "$line";
        }
    }else{

        #print "Line: $line\n";
        #print "INSERT DB C: $body\n";
        $body .= "$line";
        #print "BAD \n,$id,$type,$sectionid,$author,$dynasty,$title,$body\n";
        #$dbh->do("INSERT INTO denglou (`repoid`,`type`,`sectionid`,`author`,`dynasty`,`title`,`body`) VALUES(?,?,?,?,?,?,?)",undef,$id,$type,$sectionid,$author,$dynasty,$title,$body);
print("INSERT INTO denglou (`repoid`,`type`,`sectionid`,`author`,`dynasty`,`title`,`body`) VALUES(\"$id\",\"$type\",\"$sectionid\",\"$author\",\"$dynasty\",\"$title\",\"$body\");\n");
        my $str =decode('utf8',"$line");
        my $prefix=encode('utf8',substr($str,-5,5));
        my $surfix;

        if ($prefix =~ /^[^(]+\).+\([^)]+$/) {
            $surfix="($prefix)";
        }elsif ($prefix =~ /^[^(]+\).*/) {
            $surfix="($prefix";
        }elsif ($prefix =~ /^.*\([^)]+$/) {
            $surfix="$prefix)";
        }else {
            $surfix=$prefix;
        }

        $body=$surfix;
        $length=0;
    #    print "Last char $last_char\n";
    }
}
