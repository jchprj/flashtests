<?php
date_default_timezone_set('PRC');
/**
 * 
 * @author Administrator
 *
 */
class ClassLoader {
	
	/**
	 * 
	 *
	 */
	public static function loadClass($class, $dirs = null,$throw=true)
    {
        if (class_exists($class, false) || interface_exists($class, false)) {
            return true;
        }
		try {
	        if ((null !== $dirs) && !is_string($dirs) && !is_array($dirs)) {
	            self::loadClass('CustomException',LIB_DIR);
	            throw new CustomException('Directory argument must be a string or an array');
	        }
	        $file = $class . '.php';
	        if (!empty($dirs)) {
	            $file = $dirs.'/'.$file;
	        }
            self::_securityCheck($file);
            include $file;
	        if (!class_exists($class, false) && !interface_exists($class, false)) {
	            self::loadClass('CustomException',LIB_DIR);
	            throw new CustomException("File \"$file\" does not exist or class \"$class\" was not found in the file");
	        }
	        return true;
		} catch(Exception $e) {
			if($throw===true) {
				throw new CustomException($e->getMessage());
			}
			return false;
		}
    }
    
	public static function loadFile($filename, $dirs = null, $once = false)
    {
        self::_securityCheck($filename);

        /**
         * Search in provided directories, as well as include_path
         */
        $incPath = false;
        if (!empty($dirs) && (is_array($dirs) || is_string($dirs))) {
            if (is_array($dirs)) {
                $dirs = implode(PATH_SEPARATOR, $dirs);
            }
            $incPath = get_include_path();
            set_include_path($dirs . PATH_SEPARATOR . $incPath);
        }

        /**
         * Try finding for the plain filename in the include_path.
         */
        if ($once) {
            include_once $filename;
        } else {
            include $filename;
        }

        /**
         * If searching in directories, reset include_path
         */
        if ($incPath) {
            set_include_path($incPath);
        }

        return true;
    }
    
    /**
     * 
     *
     */
	protected static function _securityCheck($filename)
    {
        /**
         * Security check
         */
        if (preg_match('/[^a-z0-9\\/\\\\_.:-]/i', $filename)) {
            self::loadClass('CustomException',LIB_DIR);
            throw new CustomException('Security check: Illegal character in filename');
        }
    }
}
?>