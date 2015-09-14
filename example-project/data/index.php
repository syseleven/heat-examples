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
?>
