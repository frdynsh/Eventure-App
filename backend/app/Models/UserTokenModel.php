<?php
namespace App\Models;
use CodeIgniter\Model;

class UserTokenModel extends Model
{
    // Menentukan tabel database
    protected $table = 'user_tokens';

    // Menentukan primary key
    protected $primaryKey = 'id';

    // Kolom yang diizinkan untuk diisi
    protected $allowedFields = ['user_id', 'auth_key'];
}
