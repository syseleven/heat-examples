<?php
echo "<br>";
echo "Hallo";
echo "<br>";
session_start();
echo "<br>";
echo "Debug davor:".$_SESSION['tier'];
$_SESSION['tier'] = 'SPINNE';

echo "<br>";
echo "Debug danach:".$_SESSION['tier'];
echo "<br>";
echo "Server:".$_SERVER["SERVER_ADDR"];

$conn_string = "host=db0.local port=5432 dbname=syseleven user=syseleven password=syseleven_pass";
$dbconn = pg_connect($conn_string);
# so something usefull with that connection: store data on master server read from slave etc.

?>
