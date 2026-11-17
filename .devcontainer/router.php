<?php
// Router dla wbudowanego serwera PHP w Codespaces (code review).
// Codespaces przekazuje żądania przez proxy HTTPS - bez tej poprawki Laravel generowałby
// adresy http://localhost:8000. Kod kursanta nie jest modyfikowany.
if (($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https') {
    $_SERVER['HTTPS'] = 'on';
    $_SERVER['SERVER_PORT'] = 443;
}
if (!empty($_SERVER['HTTP_X_FORWARDED_HOST'])) {
    $_SERVER['HTTP_HOST'] = $_SERVER['HTTP_X_FORWARDED_HOST'];
}

// Serwer jest uruchamiany z katalogu public/ (tak jak `php artisan serve`)
return require dirname(getcwd()).'/vendor/laravel/framework/src/Illuminate/Foundation/resources/server.php';
