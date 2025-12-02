<?php

namespace App\Controllers;

use App\Models\UserModel;
use App\Models\UserTokenModel;
use CodeIgniter\API\ResponseTrait;

class LoginController extends BaseController
{
    use ResponseTrait;

    public function login()
    {
        $modelUser = new UserModel();
        $modelToken = new UserTokenModel();

        // 1. Ambil Data
        $data = $this->request->getJSON();

        if (!$data) {
            return $this->fail("Data JSON tidak valid", 400);
        }

        // 2. Validasi Input
        if (!isset($data->email) || !isset($data->password)) {
            return $this->fail("Email dan password wajib diisi", 400);
        }

        // 3. Cari User by Email
        $user = $modelUser->where('email', $data->email)->first();
        
        // 4. Verifikasi Password
        // password_verify(Input Mentah, Hash dari DB)
        if (!$user || !password_verify($data->password, $user['password'])) {
            return $this->fail("Email atau password salah", 401);
        }

        // 5. Generate Token
        // Menghasilkan token acak 64 karakter
        $token = bin2hex(random_bytes(32));

        // 6. Simpan Token ke Database
        try {
            $modelToken->insert([
                'user_id'  => $user['id'],
                'auth_key' => $token
            ]);

            // 7. Kirim Response Sukses
            // Kita kirim data user & token agar bisa disimpan di Flutter (SharedPreferences)
            $response = [
                'status' => 200,
                'message' => 'Login berhasil',
                'data' => [
                    'token' => $token,
                    'user'  => [
                        'id'    => $user['id'],
                        'nama'  => $user['nama'],
                        'email' => $user['email']
                    ]
                ]
            ];
            return $this->respond($response, 200);

        } catch (\Exception $e) {
            return $this->failServerError("Gagal membuat sesi login: " . $e->getMessage());
        }
    }
}