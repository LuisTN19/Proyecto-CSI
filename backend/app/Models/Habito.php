<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Habito extends Model
{
    protected $table = 'Habito'; 
    protected $fillable = [
        'nombre', 
        'esCompletado', 
        'user_id'
    ];
    protected $casts = [
        'esCompletado' => 'boolean',
    ];


    // 💡 Una Usuario puede tener muchos habitos asociados.
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
