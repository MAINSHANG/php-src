--TEST--
Register Alloction 002: SEND_VAL_EX uses %r0 as a temporay register
--INI--
opcache.enable=1
opcache.enable_cli=1
opcache.file_update_protection=0
opcache.jit_buffer_size=1M
opcache.protect_memory=1
--SKIPIF--
<?php require_once('../skipif.inc'); ?>
--FILE--
<?php
class A {
    public function process($call) {
		$i = 0;
		foreach (array("a", "b", "c") as $attr) {
			$call($i++, "xxx");
		}
    }
}

$a = new A();
$a->process(function($i, $v) { var_dump($i); });
?>
--EXPECT--
int(0)
int(1)
int(2)
