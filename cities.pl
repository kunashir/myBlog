open (LOG, shift ) or die "Error open logfile: $!\n";
while ($line = <LOG> )
{
  #print $line;
   if ($line =~  m/(\W*?)\s(\W+)\s/ )
   {
      print "$1 ($2)\n";
      #$ip_hash{"$1"} = $ip_hash{"$1"} + 1
    }
}


