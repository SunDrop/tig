<?php

require __DIR__ . '/../vendor/autoload.php';

phpinfo();

try {
    while (1) {
        $mongo = new MongoDB\Client('mongodb://mongo:27017');
        $dbs = $mongo->listDatabases();
    }
} catch (\Exception $e) {
    var_dump($e);
}
