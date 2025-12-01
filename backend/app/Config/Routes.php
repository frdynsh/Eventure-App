<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
$routes->get('/', 'Home::index');

// --- OTENTIKASI ---
$routes->post('registrasi', 'RegistrasiController::create'); 
$routes->post('login', 'LoginController::login');
$routes->post('logout', 'LogoutController::logout');

// --- GROUP SCHEDULES ---
$routes->group('schedules', function($routes) {
    // Mengarah ke fungsi index()
    $routes->get('/', 'ScheduleController::index');

    // Mengarah ke fungsi create()
    $routes->post('/', 'ScheduleController::create');

    // Mengarah ke fungsi update(123)
    $routes->put('(:num)', 'ScheduleController::update/$1');
    
    // Mengarah ke fungsi delete(123)
    $routes->delete('(:num)', 'ScheduleController::delete/$1');
});