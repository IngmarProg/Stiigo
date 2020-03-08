//{$define debugmode}



// kas palgamoodul lubatud !
//{$define wagemodule_enabled}

// KASUTADA VAID TESTI PERIOODIL !
//{$define autofind_test_server_ip}


// {$define mdistyle} // hetkel veel lazarus 0.9.29 ei toeta MDI'd ! Hetkel las olla kinni !
// {$ASSERTIONS ON}
//{$DEFINE FINLAND}

// for webservice
// {$DEFINE WEBSERVICE}
{$DEFINE xDEMO}
{$IFDEF WEBSERVICE}
 {$DEFINE NOGUI}
{$ENDIF}

{$DEFINE backend_is_postgre}
