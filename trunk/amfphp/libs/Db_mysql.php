<?php
/*======================================================================*\
|| #################################################################### ||
|| # vBulletin 3.0.5 -                                                # ||
|| # Nulliefied by WWL - WarezwonderLand.Com                          # ||
|| # Email : nulliefied@hotmail.com                                   # ||
|| # ---------------------------------------------------------------- # ||
|| # All PHP code in this file is ?000-2005 Jelsoft Enterprises Ltd. # ||
|| # This file may not be redistributed in whole or significant part. # ||
|| # ---------------- VBULLETIN IS NOT FREE SOFTWARE ---------------- # ||
|| # http://www.vbulletin.com | http://www.vbulletin.com/license.html # ||
|| #################################################################### ||
\*======================================================================*/

// db class for mysql
// this class is used in all scripts
// do NOT fiddle unless you know what you are doing

define('DBARRAY_NUM', MYSQL_NUM);
define('DBARRAY_ASSOC', MYSQL_ASSOC);
define('DBARRAY_BOTH', MYSQL_BOTH);

if (!defined('DB_EXPLAIN'))
{
	define('DB_EXPLAIN', false);
}

if (!defined('DB_QUERIES'))
{
	define('DB_QUERIES', false);
}

class Db_mysql {
	var $link_id = 0;

	var $errdesc = '';
	var $errno = 0;
	var $reporterror = 1;

	var $appname = 'vBulletin';
	var $appshortname = 'vBulletin (cp)';

	function connect($server, $user, $password, $dbname,$usepconnect=false,$newlink=false)
	{
		// connect to db server

		global $querytime;
		// do query

		if (DB_QUERIES) {
			global $pagestarttime;
			$pageendtime = microtime();
			$starttime = explode(' ', $pagestarttime);
			$endtime = explode(' ', $pageendtime);

			$beforetime = $endtime[0] - $starttime[0] + $endtime[1] - $starttime[1];

		}		
		$this->conTime = date('Ymd H:i:s').' rand:'.rand(1,100);
		if (0 == $this->link_id) {
			if (empty($password)) {
				if ($usepconnect) {
					$this->link_id = @mysql_pconnect($server, $user);
				} else {
					$this->link_id = @mysql_connect($server, $user);
				}
			} else {
				if ($usepconnect)
				{
					$this->link_id = @mysql_pconnect($server, $user, $password,$newlink);
				} else {
					$this->link_id = @mysql_connect($server, $user, $password,$newlink);
				}
			}
			if ($this->link_id==false) {
				$this->halt('connect failed');
			}
			$this->select_db($dbname);

			if (DB_QUERIES) {
				$pageendtime = microtime();
				$starttime = explode(' ', $pagestarttime);
				$endtime = explode(' ', $pageendtime);

				$aftertime = $endtime[0] - $starttime[0] + $endtime[1] - $starttime[1];
				$querytime += $aftertime - $beforetime;
			}
			return true;
		}
	}

	function affected_rows()
	{
		$this->rows = mysql_affected_rows($this->link_id);
		return $this->rows;
	}

	function geterrdesc()
	{
		$this->error = mysql_error($this->link_id);
		return $this->error;
	}

	function geterrno()
	{
		$this->errno = mysql_errno($this->link_id);
		return $this->errno;
	}

	function select_db($database = '') {
		// select database
		if (!empty($database))
		{
			$this->database = $database;
		}

		$connectcheck = @mysql_select_db($this->database, $this->link_id);

		if($connectcheck) {
			return true;
		} else {
			$this->halt('cannot use database ' . $this->database);
			return false;
		}
	}

	function query_unbuffered($query_string) {
		return $this->query($query_string, 'mysql_unbuffered_query');
	}

	function shutdown_query($query_string, $arraykey = 0)
	{
		global $shutdownqueries;

		if (NOSHUTDOWNFUNC AND !$arraykey)
		{
			return $this->query($query_string);
		}
		elseif ($arraykey)
		{
			$shutdownqueries["$arraykey"] = $query_string;
		}
		else
		{
			$shutdownqueries[] = $query_string;
		}
	}

	function query($query_string, $query_type = 'mysql_query')
	{
		global $query_count, $querytime;

		// do query
		try {
			$query_id = $query_type($query_string, $this->link_id);
		} catch (Exception $e) {
			throw new GException($e->getMessage(),$e->getCode());
		}
		$this->lastquery = $query_string;
		if ($query_id===false) {
			$this->halt('Invalid SQL: ' . $query_string);
		}

		$query_count++;
		
		return $query_id;
	}
    
	function getRecords($sql,$unbuffered=false)
    {
    	if($unbuffered) {
        	$qhd = $this->query_unbuffered($sql);
    	} else {
    		$qhd = $this->query($sql);
    	}
        $ret='';
        while($rs=@mysql_fetch_array($qhd,MYSQL_ASSOC)) {
            $ret[]=$rs;
        }
        $this->free_result($qhd);
        return $ret;
    }
	function fetch_array($query_id, $type = DBARRAY_ASSOC)
	{
		// retrieve row
		return @mysql_fetch_array($query_id,$type);
	}
   function fetch_assoc($query_id){   	
      return @mysql_fetch_assoc($query_id);
   }
   function fetch_row($query_id){
      return @mysql_fetch_row($query_id);
   }
   function query_first_assoc($Qstr){
      return $this->fetch_assoc($this->query($Qstr));
   }
   function query_first_row($Qstr){
      return $this->fetch_row($this->query($Qstr));
   }
	function free_result($query_id)
	{
		// retrieve row
		return @mysql_free_result($query_id);
	}
		
	function query_first($query_string, $type = DBARRAY_ASSOC)
	{
		// does a query and returns first row
		$query_id = $this->query($query_string);
		$returnarray = $this->fetch_array($query_id, $type);
		$this->free_result($query_id);
		$this->lastquery = $query_string;
		return $returnarray;
	}

	function data_seek($pos, $query_id)
	{
		// goes to row $pos
		return @mysql_data_seek($query_id, $pos);
	}

	function num_rows($query_id)
	{
		// returns number of rows in query
		return mysql_num_rows($query_id);
	}

	function num_fields($query_id)
	{
		// returns number of fields in query
		return mysql_num_fields($query_id);
	}

	function field_name($query_id, $columnnum)
	{
		// returns the name of a field in a query
		return mysql_field_name($query_id, $columnnum);
	}

	function insert_id()
	{
		// returns last auto_increment field number assigned
		return mysql_insert_id($this->link_id);
	}

	function close()
	{
		// closes connection to the database
		return mysql_close($this->link_id);
	}

	function print_query($htmlize = true)
	{
		// prints out the last query executed in <pre> tags
		$querystring = $htmlize ? htmlspecialchars($this->lastquery) : $this->lastquery;
		echo "<pre>$querystring</pre>";
	}

	function escape_string($string)
	{
		// escapes characters in string depending on Characterset
		return mysql_escape_string($string);
	}

	function halt($msg)
	{
		if ($this->link_id)
		{
			$this->errdesc = mysql_error($this->link_id);
			$this->errno = mysql_errno($this->link_id);
		}
		// prints warning message when there is an error
		global $technicalemail, $bbuserinfo, $vboptions, $_SERVER,$user_id;

		if ($this->reporterror == 1)
		{
			$sendmail_path = @ini_get('sendmail_path');
			if ($sendmail_path === '')
			{
				// no sendmail, so we're using SMTP to send mail
				$delimiter = "\r\n";
			}
			else
			{
				$delimiter = "\n";
			}

			$msg = preg_replace("#(\r\n|\r|\n)#s", $delimiter, $msg);
			$message  = 'Database error in ' . $this->appname . ' ' . $vboptions['templateversion'] . ":$delimiter$delimiter$msg$delimiter";
			$message .= 'mysql error: ' . $this->errdesc . "$delimiter$delimiter";
			$message .= 'mysql error number: ' . $this->errno . "$delimiter$delimiter";
			$message .= 'Date: ' . date('l dS of F Y h:i:s A') . $delimiter;
			$message .= "Script: http://$_SERVER[HTTP_HOST]" .  $delimiter;
			$message .= 'Referer: ' . getenv("HTTP_REFERER") . $delimiter;
			$message .= 'p_id: ' . $user_id . $delimiter;
			if ($bbuserinfo['username']) {
				$message .= 'Username: ' . $bbuserinfo['username'] . $delimiter;
			}

//			include_once('./includes/functions_log_error.php');
			if (function_exists('log_vbulletin_error')) {
				log_vbulletin_error($message, 'database');
			}

			if (!empty($technicalemail) and empty($vboptions['disableerroremail']))
			{
//				@mail ($technicalemail, $this->appshortname . ' Database error!', $message, "From: $technicalemail");
			}
            throw new GException($message,$this->errno);		
		}
	}
}

/*======================================================================*\
|| ####################################################################
|| # Downloaded: 03:50, Fri Jan 7th 2005 - www.Club2share.com
|| # CVS: $RCSfile: joinrequests.php,v $ - $Revision: 1.29 $
|| ####################################################################
\*======================================================================*/
?>