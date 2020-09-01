#SMTP server used to send alerts
$PSEmailServer = "mailserver.domain.com"

#External IPs to check
$ips = @("11.22.33.44","55.66.77.88")
#Notification recipients
$receps = @("admin1@domain.com","admin2@domain.com")

#The following function converts IP address to DNSBL name by reversing IP octets and adding them to the ".pbl.spamhaus.org" domain.
function ip_to_dnsbl_name
    {
        param ($ip)
        $ip = $ip.split(".")
        [array]::Reverse($ip)
        $ip = $ip -join "."
        $ip = $ip + ".pbl.spamhaus.org"
        $ip
     }
#The following function checks converted IP address agains Spamhaus DNSBL
function blacklist_check
    {
        param ($ips)
        foreach ($ip in $ips)
        {
            $dnsbl_name = ip_to_dnsbl_name($ip)
            if (Resolve-DnsName -DnsOnly $dnsbl_name)
            {
                Send-MailMessage -to $receps -from "dnsbl_checker@domain.com" -subject "$ip is blacklisted" -body "$ip has been blacklisted by Spamhaus.org`n https://www.spamhaus.org/query/ip/$ip"
             }
         }
     }       

blacklist_check $ips