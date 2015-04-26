use strict;
use warnings;
use LWP::UserAgent;
use utf8;
use Encode;
use Data::Dumper;
use File::Basename;

my $HTTPURL = "" ;
#my $DOWNLOAD_DIR = "./img/" ;
my $DOWNLOAD_DIR = "/usr/local/apache2/htdocs/nakazato/" ;

my $ua = LWP::UserAgent->new;
my $url = $ARGV[0];
my $outf= $ARGV[1];


my $res = $ua->get($url);
if($res->is_success){
        open(OUTF, ">".$outf) or die("Error:$!");
        #print OUTF $res->as_string;
        print OUTF Encode::encode_utf8($res->decoded_content);
        close(OUTF);
        ($HTTPURL) = $url =~ /((http|https):\/\/.*?\/)/  ;
}
else{
        die $res->status_line;
}

print $HTTPURL ."\n";

#&get_imgtag($outf);
&get_img(&get_imgtag($outf));

exit 0;

sub get_imgtag{
        my ($fname)= @_  ;
        my $buf = "";
        my @match_buf = ();

        open(INF, $fname) or die("Error:$!");
        while(<INF>){ $buf .= $_ ;}
        close(INF);
        #print "#####################################################\n" ;
        #(@match_buf) = $buf =~ /(<img.*?>)/g ;
        (@match_buf) = $buf =~ /<img src="(.*?)".*?>/g ;
        #foreach (@match_buf){
                #print $_  . "\n" ;
        #
        #}
        return @match_buf ;
        #print "#####################################################\n" ;
}

sub get_img{
        my @img_array = @_ ;
        my $url = "" ;
        my $ua = LWP::UserAgent->new;
        foreach (@img_array){
                $url = $_  ;
                if ($url !~ /http/){
                        $url = $HTTPURL . $url ;
                }
                print $url ."\n" ;
                my $res = $ua->get($url);
                if($res->is_success){
                        open(OUTF, ">".$DOWNLOAD_DIR.basename($url)) or die("Error:$!");
                        print OUTF $res->content;
                        close(OUTF);
                }
                else{
                        die $res->status_line;
                }
        }
}

1;