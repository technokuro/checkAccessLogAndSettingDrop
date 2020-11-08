 #!/usr/bin/perl

$log = $ARGV[0] || "/var/log/httpd/access_log";
$count = $ARGV[1] || 15;
$isPermanent = $ARGV[2] || "0";

if (FALSE == open(FILE , "<" . $log)){
  print "ファイルのオープンに失敗です\n";
  exit(1);
}

#カウント変数 $count{'ip'}

while($line = <FILE>){
  if ($line =~ /^([^ ]*)[^\[]+\[([^\"]+)\"([^ ]+) (\/[^ ]*) ([^\"]+)" ([^ ]+) ([^ ]+) \"([^\"]*)\" \"([^\"]*)\"$/){
    $ip = $1;
    $dateAccess = $2;
    $request = $3;
    $path = $4;
    $type = $5;
    $returnCd = $6;
    $p7 = $7;
    $p8 = $8;
    $userAgent = $9;
    #print  "ip=". $ip. " req=". $request. " path=". $path. " ret=". $returnCd. " UA=". $p9 . "\n";
    if($returnCd == "400" || $returnCd == "404"){
      if($counter{$ip}){
        $counter{$ip}++;
      }else{
        $counter{$ip} = 1;
      }
    }
  }
}
close(FILE);

while( my ($key, $value) = each(%counter) ) {
    if($value >= $counter){
      open OUT, "whois ". $key. " | grep \'route\' |";
      @ret = <OUT>;
      close OUT;
      foreach(@ret){
        if($_ =~ /^(route:)\s+(\d+\.\d+\.\d+\.\d+\/\d\d)$/){
          print "match ". $2. "\n";
	  $command = "firewall-cmd --zone=drop --add-source=". $2;
	  if($isPermanent){
 	    $command .= " --permanent";
 	  }
          system($command);
        }
      }
    }
}
if($isPermanent){
    system("firewall-cmd --reload");
}


