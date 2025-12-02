<?php

namespace App\Controllers;

use App\Models\UserModel;
use CodeIgniter\API\ResponseTrait; // Fitur standar CI4 untuk API

class RegistrasiController extends BaseController
{
    // Menggunakan Trait ini agar kita bisa pakai $this->respondCreated(), $this->fail(), dll.
    use ResponseTrait;

    public function create()
    {
        $model = new UserModel();

        // 1. Ambil data JSON dari Request
        $data = $this->request->getJSON();

        // Cek jika JSON kosong atau tidak valid
        if (!$data) {
            return $this->fail("Data JSON tidak valid atau kosong", 400);
        }

        // 2. Validasi Kelengkapan Data
        if (!isset($data->nama) || !isset($data->email) || !isset($data->password)) {
            return $this->fail("Nama, email, dan password wajib diisi", 400);
        }

        // 3. Validasi Panjang Password (Opsional tapi disarankan)
        if (strlen($data->password) < 6) {
            return $this->fail("Password minimal 6 karakter", 400);
        }

        // 4. Cek Duplikasi Email
        // Kita cari apakah email ini sudah ada di tabel users
        $existingUser = $model->where('email', $data->email)->first();
        if ($existingUser) {
            // Kode 409 (Conflict) lebih tepat untuk data duplikat daripada 400
            return $this->fail("Email sudah terdaftar", 409);
        }

        // 5. Simpan ke Database
        // PERHATIKAN: Kita mengirim password MENTAH ($data->password).
        // UserModel Anda (fungsi hashPassword) akan otomatis mengenkripsinya.
        try {
            $model->insert([
                'nama'     => $data->nama,
                'email'    => $data->email,
                'password' => $data->password 
            ]);

            // Respons Sukses (201 Created)
            $response = [
                'status'  => 201,
                'message' => 'Registrasi berhasil. Silakan login.'
            ];
            return $this->respondCreated($response);

        } catch (\Exception $e) {
            // Tangani error database jika ada
            return $this->failServerError("Gagal menyimpan data: " . $e->getMessage());
        }
    }
}