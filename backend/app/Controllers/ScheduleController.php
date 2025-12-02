<?php 
namespace App\Controllers;

use App\Models\ScheduleModel;
use CodeIgniter\API\ResponseTrait;

class ScheduleController extends BaseController
{
    // Gunakan trait ini untuk standar response API
    use ResponseTrait;

    // 1. CREATE (Simpan Jadwal Baru)
    public function create()
    {
        $model = new ScheduleModel();
        $data = $this->request->getJSON();

        if (!$data) {
            return $this->fail("Data JSON tidak valid", 400);
        }

        // Validasi ID User
        if (!isset($data->user_id)) {
            return $this->fail("User ID wajib ada", 400);
        }

        // Cek Duplikasi (Agar tidak simpan konser yang sama 2x untuk user yang sama)
        $exists = $model->where('user_id', $data->user_id)
                        ->where('external_id', $data->external_id)
                        ->first();

        if ($exists) {
            // Gunakan 409 Conflict untuk data duplikat
            return $this->fail("Event ini sudah ada di jadwal Anda", 409);
        }

        try {
            // Simpan Data
            $model->insert([
                'user_id'       => $data->user_id,
                'external_id'   => $data->external_id,
                'event_name'    => $data->event_name,
                'event_date'    => $data->event_date, 
                'venue_name'    => $data->venue_name,
                'image_url'     => $data->image_url ?? '',
                'personal_notes'=> $data->personal_notes ?? '', 
                'status'        => 'Plan' 
            ]);

            return $this->respondCreated([
                'status' => 201,
                'message' => 'Jadwal berhasil disimpan'
            ]);

        } catch (\Exception $e) {
            return $this->failServerError("Gagal menyimpan jadwal: " . $e->getMessage());
        }
    }

    // 2. READ (Lihat Daftar Jadwal per User)
    public function index()
    {
        $model = new ScheduleModel();
        // Ambil dari query params: http://localhost:8080/schedules?user_id=1
        $userId = $this->request->getVar('user_id'); 

        if (!$userId) {
            return $this->fail("Parameter user_id diperlukan", 400);
        }

        $data = $model->where('user_id', $userId)->findAll();
        
        return $this->respond([
            'status' => 200,
            'message' => 'Data ditemukan',
            'data' => $data
        ], 200);
    }

    // 3. UPDATE (Edit Catatan / Status)
    public function update($id = null)
    {
        $model = new ScheduleModel();
        $data = $this->request->getJSON();
        
        // Cek apakah data jadwal ada
        $jadwal = $model->find($id);
        if (!$jadwal) {
            return $this->failNotFound("Jadwal tidak ditemukan");
        }

        // Siapkan data update
        $updateData = [];
        if (isset($data->personal_notes)) $updateData['personal_notes'] = $data->personal_notes;
        if (isset($data->status)) $updateData['status'] = $data->status;

        if (empty($updateData)) {
            return $this->fail("Tidak ada data yang diupdate", 400);
        }

        try {
            $model->update($id, $updateData);
            return $this->respond([
                'status' => 200,
                'message' => 'Jadwal diperbarui'
            ], 200);
        } catch (\Exception $e) {
            return $this->failServerError("Gagal update: " . $e->getMessage());
        }
    }

    // 4. DELETE (Hapus Jadwal)
    public function delete($id = null)
    {
        $model = new ScheduleModel();
        
        if (!$model->find($id)) {
            return $this->failNotFound("Jadwal tidak ditemukan");
        }
        
        try {
            $model->delete($id);
            return $this->respond([
                'status' => 200,
                'message' => 'Jadwal dihapus'
            ], 200);
        } catch (\Exception $e) {
            return $this->failServerError("Gagal hapus: " . $e->getMessage());
        }
    }
}