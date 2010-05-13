<?php
class Command
{
	function sendCommand($arr)
	{
		$newArray=array(1, $arr[2], $arr[3], $arr[4], $arr[5]);
		return $arr;
	}

	function test()
	{
		$db = DbConn::getDBO();
		$player= $db->getRecords("select p_id,p_name,passport,is_online,p_online_time from player where p_id=5");
		$db->close();
		$arr="";
		if(is_array($player)){
			$arr="<table><tr><td widht='20'>pid:</td><td>{$player[0]['p_id']}</td></tr></table>";
		}
		return $arr;
	}
}
?>