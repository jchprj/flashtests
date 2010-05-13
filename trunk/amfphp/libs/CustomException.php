<?php
class CustomException extends Exception {
	
	private static $e = null;
	
	public function __construct($msg,$code=1) {		
		parent::__construct($msg,$code);
		self::$e = & $this;
	}
	
	public static function & getError() {
		return self::$e;
	}
}
?>