<?php namespace App\Models;

use CodeIgniter\Model;

class ScheduleModel extends Model
{
    protected $table = 'schedules'; 
    protected $primaryKey = 'id';
    protected $allowedFields = [
        'user_id', 
        'external_id', 
        'event_name', 
        'event_date', 
        'venue_name', 
        'image_url', 
        'personal_notes', 
        'status'
    ];
}