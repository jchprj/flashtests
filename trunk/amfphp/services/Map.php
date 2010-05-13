<?php
class Map
{
	private $userName="root";
	private $userPwd="vertrigo";
	private $dbName="test";
	private $serverName="localhost";
	function __construct()
	{
		//connect db
		$this->conn=mysql_connect($this->serverName, $this->userName, $this->userPwd);
		//select db
		$this->my_db=mysql_select_db($this->dbName, $this->conn);
	}
	function createRecord()
	{
			for($i=0;$i<20;$i++)
			{
				for($j=0;j<20;$j++)
				{
					$type=mt_rand(0, 7);
					if($type==7)
					{
						$level=0;
						$userId=mt_rand(5000, 95000);
					}
					if($type<7)
					{
						$level=mt_rand(0, 9);
						$userId=0;
					}
					mysql_query("insert into mapdata values(null, '$i', '$j', '$type', '$level', '$userId')");
				}
			}
	}
			
	//insert record
	function insertRecord($intX, $intY, $intType, $intLevel, $intId)
	{
		mysql_query("insert into mapdata values(null, '$intX', '$intY', '$intType', '$intLevel', '$intId')");
	}
	//get lines
	function getTotalLine()
	{
		$result=mysql_query("select count(*) from mapdata");
		$num=mysql_fetch_row($result);
		return (int)$num[0];
	}
	function getLine($intX, $intY)
	{
		$result=mysql_query("select * from mapdata where x='$intX' and y='$intY'");
		$str1=mysql_fetch_row($result);
		return $str1;
	}
}
?>