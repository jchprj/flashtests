<?
echo "dd";
include 'init.php';

$db = DbConn::getDBO();
$p_id=$_REQUEST['p_id'];
echo "mid<br/>";
$player= $db->getRecords("select p_id,p_name,passport,is_online,p_online_time from player where p_id={$p_id}");

echo "end";
$db->close();
if(is_array($player)){
	echo "<table><tr><td widht='20'>pid:</td><td>{$player[0]['p_id']}</td></tr></table>";
}
?>
