<?php
//** 
* Author: fs, bi-sec GmbH
* Purpose: Script to download the current Microsoft Azure IPv4 addresses and create files with 950k IP addresses each to use in SIEM like Microsoft Sentinel.
* Source for MS-IPs: https://learn.microsoft.com/en-us/microsoft-365/enterprise/urls-and-ip-address-ranges?view=o365-worldwide
*/


ini_set('memory_limit', '2048M');

$url = "https://endpoints.office.com/endpoints/worldwide?clientrequestid=b10c5ed1-bad1-445f-b386-b919946339a7";

$curl = curl_init();
curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
curl_setopt($curl, CURLOPT_URL, $url);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
$result = curl_exec($curl);
curl_close($curl);

$result = json_decode($result,true);
$ipAddresses = array();

$dirpath = basename("."); // Write to current dir
$filepath = $dirpath . "/" . 'ipaddresses_all.txt';

// Open file for read
if($file = @fopen($filepath, 'r')) {
    $previousIps = explode(PHP_EOL, @fread($file, filesize($filepath)));

    // Insert previous ips from txt
    foreach($previousIps as $key => $prevIp) {
        if(empty($prevIp)) {
            continue;
        }
        $ipAddresses[$prevIp] = true;
    }
}

// Loop through services
foreach($result as $service) {

    // Check if ips property exsits
    if(!@$service["ips"]) {
        continue;
    }

    $ipArray = $service["ips"];

    // Loop through ips
    foreach($ipArray as $ip) {
        $ipParts = explode("/", $ip);
        $address = $ipParts[0];
        $subnet  = $ipParts[1];

        // non valid data
        if(empty($ipParts)) {
            continue;
        }

        $range = array();

        // Check if ip is valid ipv4
        if(filter_var($address, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)) { 
            // Start ip from subnet
            $start = ip2long($address) & ((-1 << (32 - (int)$subnet)));
            // last ip from subnet
            $end   = ip2long($address) + pow(2, (32 - (int)$subnet)) - 1;

            // Loop through ips in range from start to last
            foreach(range($start, $end) as $newIp) {
                $ipAddresses[long2ip($newIp)] = true;
            }
        } 
        // Check if ip is valid ipv6
        else if(filter_var($address, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6)) {
            
            // Check if ip-address is empty
            if(empty($address)) {
                continue;
            }

            // Check if subnet is single host
            if($subnet === "128") {
                $ipAddresses[$address] = true;
            } else {
                $ipAddresses[$ip] = true;
            }
        }
        else {
            echo "'" . $address . "' with subnet '/" . $subnet . "' is not a valid ip";
        }
    }
}

fclose($file);

// Open file to write
if(!$file = @fopen($filepath, 'w+')) {
    die("File write failed");
}

// Create file
if(!file_exists($filepath)) {
    touch($filepath);
}

// Insert ip-addresses into txt file
if(!empty($ipAddresses)) {
    fwrite($file,  implode(PHP_EOL, array_keys($ipAddresses)));
}

// Create array chunk due to sentinal limit of 1 mio
$array_chunks = array_chunk(array_keys($ipAddresses), 950000);

// Create sub files and insert chunks into it
foreach($array_chunks as $key => $array_chunk) {
    $filename = "ipaddresses_" . str_pad($key+1, 2, "0", STR_PAD_LEFT) . ".txt";
    $filepath = $dirpath . DIRECTORY_SEPARATOR . $filename;

    if(!file_exists($filepath)) {
        touch($filepath);
    }

    if(!$file = @fopen($filepath, 'w+')) {
        die("Single File write failed");
    }

    fwrite($file,  implode(PHP_EOL, $array_chunk));
    fclose($file);
}
