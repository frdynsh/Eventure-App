<?php

namespace App\Controllers;

use App\Models\UserTokenModel;
use CodeIgniter\API\ResponseTrait;

class LogoutController extends BaseController
{
    use ResponseTrait;

    public function logout()
    {
        // 1. Ambil User ID dari input JSON
        $data = $this->request->getJSON();
        $userId = $data->user_id ?? null;

        if (!$userId) {
            return $this->fail("User ID diperlukan", 400);
        }

        // 2. Hapus Token dari Database
        $modelToken = new UserTokenModel();
        
        // Menghapus semua token milik user tersebut (Clean logout)
        $modelToken->where('user_id', $userId)->delete();

        // 3. Berikan Respon Sukses
        return $this->respond([
            'status' => 200,
            'message' => 'Berhasil Logout. Token dihapus.'
        ], 200);
    }
}