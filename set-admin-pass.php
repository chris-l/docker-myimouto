<?php
use Zend\Console\ColorInterface as Color;

/**
 * Boot Rails
 */
require __DIR__ . '/config/boot.php';

/**
 * Create console and migrator
 */
$c        = new Rails\Console\Console();
$migrator = new Rails\ActiveRecord\Migration\Migrator();
$adminName = getenv("ADMIN_USERNAME");
$adminPass = getenv("ADMIN_PASSWORD");

Rails\ActiveRecord\ActiveRecord::connection()->executeSql(
        'UPDATE users SET name = ?, password_hash = ? WHERE id = 1',
            $adminName, User::sha1($adminPass)
);

