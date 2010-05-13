<?php
class DbConn {
	private static $DBO = array();
	
	private static $dbconn = array('common'=>array('host'=>'127.0.0.1',
											   'username'=>'root',
											   'password'=>'root',
											   'db_name'=>'xjtest1',
											   'port'=>3306),
							  );
	
	public static function & getDBO($k='common') {		
		if(!isset(self::$DBO[$k]) || !is_object(self::$DBO[$k])) {			
			$config = self::getConfig('dbconn',$k);
			ClassLoader::loadClass('Db_mysql',LIB_DIR.'/');
			$db = new Db_mysql();
			$db->connect($config['host'], $config['username'], $config['password'],$config['db_name']);
			self::$DBO[$k] = & $db;
//			self::$DBO[$k]->query_first("SET NAMES utf8;");
//			self::$DBO[$k]->query_first("SET CHARACTER_SET_CLIENT=utf8;");
//			self::$DBO[$k]->query_first("SET CHARACTER_SET_RESULTS=utf8;");
			
		}
		return self::$DBO[$k];
	}
	
	public static function destroy() {
		if(is_array(self::$DBO) && count(self::$DBO)>0) {
			foreach(self::$DBO as &$obj) {
				if(is_object($obj)) {
					$obj->close();
				}
				$obj = null;
			}
		}
		self::$DBO = null;
	}

	/**
	 * 获取配置数据
	 * @param String $var 变量名
	 * @param String $key 变量键名
	 * @return Mix $return
	 */
	private static function getConfig($var,$key=null) {
		if(isset(self::${$var}) && $key===null) {
			return self::${$var};
		} elseif(isset(self::${$var}) && isset(self::${$var}[$key])) {
			return self::${$var}[$key];
		} else {
			return null;
		}
	}
}
?>