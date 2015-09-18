<html>
<head>
<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type"><title>Home</title>
<link href='https://fonts.googleapis.com/css?family=Poiret One' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
</head>
<body>

<div class=container>
<div class=page-header>
<div style="font-family: Poiret One; font-size: 1.5em; letter-spacing: 0.3em;">

<?php
echo "<br>";
echo "<h1> AnyApp </h1>";
echo "<br>";
session_start();
echo "<br>";
if (strpos($_SESSION['upstream-servers'], $_SERVER['SERVER_ADDR']) !== false) {
} else {
	$_SESSION['upstream-servers'] = $_SERVER["SERVER_ADDR"]." ".$_SESSION['upstream-servers'];
}
echo "<br>";
echo "Upstream server list:<br>".$_SESSION['upstream-servers'];
echo "<br>";
echo "<br>";
echo "Backend server ".$_SERVER["SERVER_ADDR"];
echo "<br>";

$conn_string = "host=db0.local port=5432 dbname=syseleven user=syseleven password=syseleven_pass";
$dbconn = pg_connect($conn_string);
# so something usefull with that connection: store data on master server read from slave etc.


?>

</div>
</div>
</div>
</body>
</html>

