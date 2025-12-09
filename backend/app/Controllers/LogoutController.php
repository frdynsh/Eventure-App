<?php

namespace App\Controllers;

use App\Models\UserModel;
use App\Models\UserTokenModel;
use CodeIgniter\API\ResponseTrait;

class LogoutController extends BaseController
{
    use ResponseTrait;

    public function logout()
    {
        // 1. Ambil data JSON
        $data = $this->request->getJSON();
        $userId = $data->user_id ?? null;

        // Validasi dasar
        if (!$userId) {
            return $this->fail("User ID diperlukan", 400);
        }

        // 2. Cek apakah user benar-benar ada
        $userModel = new UserModel();
        $user = $userModel->find($userId);

        if (!$user) {
            return $this->fail("User tidak ditemukan", 404);
        }

        // 3. Cek apakah user masih punya token (masih login)
        $tokenModel = new UserTokenModel();
        $token = $tokenModel->where('user_id', $userId)->first();

        if (!$token) {
            return $this->fail("User sudah logout atau token tidak ditemukan", 400);
        }

        // 4. Hapus token (logout sesungguhnya)
        $tokenModel->where('user_id', $userId)->delete();

        // 5. Response sukses
        return $this->respond([
            'status'  => 200,
            'message' => 'Logout berhasil. Token dihapus.'
        ], 200);
    }
}
