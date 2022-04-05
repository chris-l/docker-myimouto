<?php
namespace MyImouto;

class LocalConfig extends DefaultConfig
{
    /**
     * Don't change these vars. Instead, use docker env vars to change these values.
     */
    public $app_name    = "<APP_NAME>";
    public $server_host = "<SERVER_HOST>";
    public $url_base    = "<URL_BASE>";
    /************************************************/

    /**
     * Place your custom configuration from this point,
     * instead of modifying the default_config.php file.
     *
     * Values placed here will overwrite the values in the parent class.
     * List the properties you want to overwrite.
     *
     * Restart the docker container after changing this file.
     */
    public $admin_contact = 'admin@myimouto';
}
