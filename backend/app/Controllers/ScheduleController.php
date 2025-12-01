<?php namespace App\Controllers;

use App\Models\ScheduleModel;

class ScheduleController extends BaseController
{
    // 1. CREATE (Simpan Jadwal Baru)
    public function create()
    {
        $model = new ScheduleModel();
        $data = $this->request->getJSON();

        // Validasi ID User
        if (!isset($data->user_id)) {
            return $this->failResponse("User ID wajib ada", 400);
        }

        // Cek Duplikasi (Agar tidak simpan konser yang sama 2x)
        $exists = $model->where('user_id', $data->user_id)
                        ->where('external_id', $data->external_id)
                        ->first();

        if ($exists) {
            return $this->failResponse("Event ini sudah ada di jadwal Anda", 400);
        }

        // Simpan Data
        $model->insert([
            'user_id'       => $data->user_id,
            'external_id'   => $data->external_id,
            'event_name'    => $data->event_name,
            'event_date'    => $data->event_date, // Pastikan format YYYY-MM-DD HH:mm:ss
            'venue_name'    => $data->venue_name,
            'image_url'     => $data->image_url,
            'personal_notes'=> $data->personal_notes ?? '', // Default kosong
            'status'        => 'Plan' // Default Plan
        ]);

        return $this->successResponse("Jadwal berhasil disimpan", [], 201);
    }

    // 2. READ (Lihat Daftar Jadwal per User)
    public function index()
    {
        $model = new ScheduleModel();
        $userId = $this->request->getVar('user_id'); // Ambil dari ?user_id=1

        if (!$userId) {
            return $this->failResponse("Parameter user_id diperlukan", 400);
        }

        $data = $model->where('user_id', $userId)->findAll();
        return $this->successResponse("Data ditemukan", $data);
    }

    // 3. UPDATE (Edit Catatan / Status)
    public function update($id = null)
    {
        $model = new ScheduleModel();
        $data = $this->request->getJSON();
        
        // Cek apakah data ada
        if (!$model->find($id)) {
            return $this->failResponse("Jadwal tidak ditemukan", 404);
        }

        // Siapkan data update (Hanya update yang dikirim saja)
        $updateData = [];
        if (isset($data->personal_notes)) $updateData['personal_notes'] = $data->personal_notes;
        if (isset($data->status)) $updateData['status'] = $data->status;

        $model->update($id, $updateData);
        return $this->successResponse("Jadwal diperbarui");
    }

    // 4. DELETE (Hapus Jadwal)
    public function delete($id = null)
    {
        $model = new ScheduleModel();
        if (!$model->find($id)) {
            return $this->failResponse("Jadwal tidak ditemukan", 404);
        }
        
        $model->delete($id);
        return $this->successResponse("Jadwal dihapus");
    }
}